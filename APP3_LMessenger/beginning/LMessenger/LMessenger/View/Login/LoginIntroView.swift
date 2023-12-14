//
//  LoginIntroView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/14/23.
//

import SwiftUI

struct LoginIntroView: View {
    @State private var isPresentedLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Text("환영합니다.")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color.bkText)
                
                Text("무료 메시지에 영상통화, 음성통화를 부담없이 즐겨보세요!")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.greyDeep)
                
                Spacer()
                
                Button(action: {
                    isPresentedLoginView.toggle()
                }, label: {
                    Text("로그인")
                })
                .buttonStyle(LoginButtonStyle(textColor: .lineAppColor))
            } // VStack
            .navigationDestination(isPresented: $isPresentedLoginView) {
                LoginView()
            }
        }
    }
}

#Preview {
    LoginIntroView()
}
