//
//  LoginView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("로그인")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.bkText)
                    .padding(.top, 80)
                Text("아래 제공되는 서비스로 로그인을 해주세요.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.greyDeep)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                authViewModel.send(action: .googleLogin)
            }, label: {
                Text("Google로 로그인")
            })
            .buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
            
            Button(action: {
                // TODO: Apple Login
            }, label: {
                Text("Apple로 로그인")
            })
            .buttonStyle(LoginButtonStyle(textColor: .bkText, borderColor: .greyLight))
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("back")
                })
            }
        }
        .overlay(
            Group {
                if authViewModel.isLoading {
                    ProgressView()
                }
            }
        )
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel(container: .init(services: StubService())))
}
