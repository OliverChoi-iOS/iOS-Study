//
//  ChatView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI
import PhotosUI
import SwiftUIIntrospect

struct ChatView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @StateObject var viewModel: ChatViewModel
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.chatBg)
            
            ScrollViewReader { proxy in
                List {
                    Group {
                        if viewModel.chatDataList.isEmpty {
                            Color.chatBg
                        } else {
                            contentView
                        }
                        
                        Section {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color.chatBg)
                                .id("bottom")
                        }
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.chatBg)
                    .listSectionSeparator(.hidden)
                    .buttonStyle(PlainButtonStyle())
                }
                .background(Color.chatBg)
                .listStyle(.plain)
                .onChange(of: viewModel.chatDataList.last?.chats ?? [], perform: { newValue in
                    proxy.scrollTo("bottom", anchor: .bottom)
                })
            }
        }
        .background(Color.chatBg)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color.chatBg, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button(action: {
                    navigationRouter.pop()
                }, label: {
                    Image("back")
                })
                
                Text(viewModel.otherUser?.name ?? "대화방이름")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.bkText)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Image("search_chat")
                Image("bookmark")
                Image("settings")
            }
        }
        .keyboardToolbar(height: 50, view: {
            HStack(spacing: 13) {
                Button(action: {
                    
                }, label: {
                    Image("other_add")
                })
                
                PhotosPicker(
                    selection: $viewModel.imageSelection,
                    matching: .images
                ) {
                    Image("image_add")
                }
                
                Button(action: {
                    
                }, label: {
                    Image("photo_camera")
                })
                
                TextField("", text: $viewModel.message)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.bkText)
                    .focused($isFocused)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color.greyCool)
                    .cornerRadius(20)
                
                Button(action: {
                    viewModel.send(action: .addChat(viewModel.message))
                    isFocused = false
                }, label: {
                    Image("send")
                })
                .disabled(viewModel.message.isEmpty)
            }
            .padding(.horizontal, 27)
        })
        .onAppear {
            viewModel.send(action: .load)
        }
    }
    
    var contentView: some View {
        ForEach(viewModel.chatDataList) { chatData in
            Section {
                ForEach(chatData.chats) { chat in
                    if let message = chat.message {
                        ChatItemView(
                            message: message,
                            direction: viewModel.getDirection(id: chat.userId),
                            date: chat.date
                        )
                    } else if let photoURL = chat.photoURL {
                        ChatImageItemView(urlString: photoURL, direction: viewModel.getDirection(id: chat.userId))
                    }
                }
            } header: {
                headerView(dateStr: chatData.dateStr)
            }
        }
    }
    
    func headerView(dateStr: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: 76, height: 20)
                .background(Color.chatNotice)
                .cornerRadius(50)
            
            Text(dateStr)
                .font(.system(size: 10))
                .foregroundStyle(Color.bgWh)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.chatBg)
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    let navigationRouter: NavigationRouter = .init()
    
    return ChatView(
        viewModel: .init(
            container: container,
            chatRoomId: "chatRoom1_id",
            myUserId: "user1_id",
            otherUserId: "user2_id"
        )
    )
    .environmentObject(navigationRouter)
}
