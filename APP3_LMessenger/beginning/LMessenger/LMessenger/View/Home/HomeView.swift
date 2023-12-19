//
//  HomeView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            contentView
                .fullScreenCover(item: $viewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView()
                    case let .otherProfile(userId):
                        OtherProfileView()
                    }
                }
        }
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
                    Image("bookmark")
                    Image("notifications")
                    Image("person_add")
                    Button(action: {
                        // TODO:
                    }, label: {
                        Image("settings")
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
            
            searchButton
                .padding(.bottom, 24)
            
            HStack {
                Text("친구")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.bkText)
                Spacer()
            }
            .padding(.horizontal, 30)
            
            if viewModel.users.isEmpty {
                Spacer(minLength: 89)
                emptyView
            } else {
                LazyVStack {
                    ForEach(viewModel.users, id: \.id) { user in
                        Button {
                            viewModel.send(action: .presentOtherProfileView(user.id))
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
                    }
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
            
            Image("person")
                .resizable()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .padding(.horizontal, 30)
        .onTapGesture {
            viewModel.send(action: .presentMyProfileView)
        }
    }
    
    var searchButton: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(height: 36)
                .background(Color.greyCool)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            HStack {
                Text("검색")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.greyLightVer2)
                Spacer()
            }
            .padding(.leading, 22)
        }
        .padding(.horizontal, 30)
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
    HomeView(viewModel: .init(container: .init(services: StubService()), userId: "user1_id"))
}
