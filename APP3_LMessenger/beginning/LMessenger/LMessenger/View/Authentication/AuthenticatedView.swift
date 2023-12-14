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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init())
}
