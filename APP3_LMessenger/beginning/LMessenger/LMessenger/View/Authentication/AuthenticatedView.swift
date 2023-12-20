//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    @StateObject private var navigationRouter: NavigationRouter
    
    init(
        authViewModel: AuthenticationViewModel,
        navigationRouter: NavigationRouter
    ) {
        _authViewModel = StateObject(wrappedValue: authViewModel)
        _navigationRouter = StateObject(wrappedValue: navigationRouter)
    }
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
            case .authenticated:
                MainTabView()
                    .environmentObject(navigationRouter)
            }
        }
        .environmentObject(authViewModel)
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
    }
}

#Preview {
    return AuthenticatedView(
        authViewModel: .init(container: .init(services: StubService())),
        navigationRouter: .init()
    )
}
