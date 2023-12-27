//
//  HomeView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        LMessengerNavigationStackView {
            contentView
                .fullScreenCover(item: $viewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView(viewModel: .init(container: container, userId: viewModel.userId))
                    case let .otherProfile(userId):
                        OtherProfileView(
                            viewModel: .init(container: container, userId: userId),
                            goToChat: { otherUser in
                                viewModel.send(action: .goToChat(otherUser))
                            }
                        )
                    case .setting:
                        SettingView(viewModel: .init())
                    }
                }
        }
        .environmentObject(viewModel)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                .onAppear(perform: {
                    viewModel.send(action: .load)
                })
        case .loading:
            LoadingView()
        case .success:
            loadedView
                .toolbar {
                    Image(decorative: "bookmark")
                    Image(decorative: "notifications")
                    Image(decorative: "person_add")
                    
                    Button(action: {
                        viewModel.send(action: .presentModal(.setting))
                    }, label: {
                        Image("settings", label: Text("설정"))
                    })
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView {
            profileView
                .padding(.bottom, 30)
            
            NavigationLink(value: NavigationDestination.search(myUserId: viewModel.userId)) {
                SearchButton()
            }
            .padding(.bottom, 24)
            
            HStack {
                Text("친구")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.bkText)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
            .padding(.horizontal, 30)
            
            if viewModel.users.isEmpty {
                Spacer(minLength: 89)
                emptyView
            } else {
                LazyVStack {
                    ForEach(viewModel.users, id: \.id) { user in
                        /*
                        Button {
                            viewModel.send(action: .presentModal(.otherProfile(user.id)))
                        } label: {
                            HStack(spacing: 8) {
                                Image("person")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                Text(user.name)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.bkText)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                        }
                         */
                        HStack(spacing: 8) {
                            Image("person")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            Text(user.name)
                                .font(.system(size: 12))
                                .foregroundStyle(Color.bkText)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.send(action: .presentModal(.otherProfile(user.id)))
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(user.name)
                        .accessibilityAddTraits(.isButton)
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
    
    var profileView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.myUser?.name ?? "이름")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.bkText)
                
                Text(viewModel.myUser?.descripton ?? "상태 메시지 입력")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.greyDeep)
            }
            
            Spacer()
            
            URLImageView(urlString: viewModel.myUser?.profileURL)
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .padding(.horizontal, 30)
        .onTapGesture {
            viewModel.send(action: .presentModal(.myProfile))
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(Text("내 프로필을 보려면 두번 탭하십시오."))
        .accessibilityAction {
            viewModel.send(action: .presentModal(.myProfile))
        }
        /*
        .accessibilityRepresentation {
            Button("내프로필보기") {
                viewModel.send(action: .presentModal(.myProfile))
            }
        }
         */
        /*
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("내프로필보기"))
         */
    }
    
    var emptyView: some View {
        VStack {
            VStack(spacing: 3) {
                Text("친구를 추가해보세요.")
                    .foregroundStyle(Color.bkText)
                Text("큐알코드나 검색을 이용해서 친구를 추가해보세요.")
                    .foregroundStyle(Color.greyDeep)
            }
            .font(.system(size: 16))
            .padding(.bottom, 30)
            
            Button(action: {
                viewModel.send(action: .requestContacts)
            }, label: {
                Text("친구추가")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.bkText)
                    .padding(.vertical, 9)
                    .padding(.horizontal, 24)
            })
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Color.greyLight)
            )
        }
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    
    return HomeView(
        viewModel: .init(
            container: container,
            userId: "user1_id"
        )
    )
    .environmentObject(container)
}
