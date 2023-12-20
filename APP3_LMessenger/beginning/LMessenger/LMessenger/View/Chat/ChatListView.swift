//
//  ChatListView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel: ChatListViewModel
    
    var body: some View {
        LMessengerNavigationStackView {
            ScrollView {
                NavigationLink(value: NavigationDestination.search) {
                    SearchButton()
                }
                .padding(.vertical, 14)
                
                ForEach(viewModel.chatRooms, id: \.chatRoomId) { chatRoom in
                    ChatRoomCell(chatRoom: chatRoom, userId: viewModel.userId)
                }
            }
            .navigationTitle("대화")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.send(action: .load)
            }
        }
    }
}

fileprivate struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let userId: String
    
    var body: some View {
        NavigationLink(value: NavigationDestination.chat(chatRoom)) {
            HStack(spacing: 8) {
                Image("person")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(chatRoom.otherUserName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.bkText)
                    if let lastMessage = chatRoom.lastMessage {
                        Text(lastMessage)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.greyDeep)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    let navigationRouter: NavigationRouter = .init()
    
    return ChatListView(
        viewModel: .init(
            container: container,
            navigationRouter: navigationRouter,
            userId: "user1_id"
        )
    )
    .environmentObject(navigationRouter)
}
