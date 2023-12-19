//
//  OtherProfileView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import SwiftUI

struct OtherProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: OtherProfileViewModel
    
    var goToChat: (User) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("profile_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    descriptionView
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 58)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("close")
                    }
                }
            }
            .task {
                await viewModel.getUser()
            }
        }
    }
    
    var profileView: some View {
        URLImageView(urlString: viewModel.userInfo?.profileURL)
            .frame(width: 80, height: 80)
            .clipShape(Circle())
    }
    
    var nameView: some View {
        Text(viewModel.userInfo?.name ?? "이름")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.bgWh)
    }
    
    var descriptionView: some View {
        Text(viewModel.userInfo?.descripton ?? "")
            .font(.system(size: 14))
            .foregroundStyle(Color.bgWh)
    }
    
    var menuView: some View {
        HStack(alignment: .top, spacing: 50) {
            ForEach(OtherProfileMenuType.allCases, id: \.self) { menu in
                Button(action: {
                    if menu == .chat, let userInfo = viewModel.userInfo {
                        dismiss()
                        goToChat(userInfo)
                    }
                }, label: {
                    VStack(alignment: .center) {
                        Image(menu.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        Text(menu.description)
                            .font(.system(size: 10))
                            .foregroundStyle(Color.bgWh)
                    }
                })
            }
        }
    }
}

#Preview {
    OtherProfileView(
        viewModel: .init(
            container: .init(services: StubService()),
            userId: "user1_id"
        ),
        goToChat: { _ in }
    )
}
