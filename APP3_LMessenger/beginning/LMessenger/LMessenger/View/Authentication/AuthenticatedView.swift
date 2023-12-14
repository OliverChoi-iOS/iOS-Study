//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    
    init(authViewModel: AuthenticationViewModel) {
        _authViewModel = StateObject(wrappedValue: authViewModel)
    }
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
    }
}

#Preview {
    return AuthenticatedView(authViewModel: .init(container: .init(services: StubService())))
}
