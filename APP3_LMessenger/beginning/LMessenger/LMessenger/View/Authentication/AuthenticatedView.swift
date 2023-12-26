//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var authViewModel: AuthenticationViewModel
    
    init(
        authViewModel: AuthenticationViewModel
    ) {
        _authViewModel = StateObject(wrappedValue: authViewModel)
    }
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
            case .authenticated:
                MainTabView()
                    .environment(\.managedObjectContext, container.searchDataController.persistantContainer.viewContext)
            }
        }
        .preferredColorScheme(container.appearanceController.appearance.colorScheme)
        .environmentObject(authViewModel)
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
        }
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    
    return AuthenticatedView(
        authViewModel: .init(container: container)
    )
    .environmentObject(container)
}
