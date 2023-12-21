//
//  AuthenticatedView.swift
//  LMessenger
//
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    @StateObject private var navigationRouter: NavigationRouter
    @StateObject private var searchDataController: SearchDataController
    
    init(
        authViewModel: AuthenticationViewModel,
        navigationRouter: NavigationRouter,
        searchDataController: SearchDataController
    ) {
        _authViewModel = StateObject(wrappedValue: authViewModel)
        _navigationRouter = StateObject(wrappedValue: navigationRouter)
        _searchDataController = StateObject(wrappedValue: searchDataController)
    }
    
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
            case .authenticated:
                MainTabView()
                    .environment(\.managedObjectContext, searchDataController.persistantContainer.viewContext)
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
        navigationRouter: .init(),
        searchDataController: .init()
    )
}
