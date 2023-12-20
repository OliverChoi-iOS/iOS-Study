//
//  LMessengerNavigationStackView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI

struct LMessengerNavigationStackView<Content: View>: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var content: () -> Content
    
    init(
        content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    var body: some View {
        NavigationStack(path: $navigationRouter.destinations) {
            content()
                .navigationDestination(for: NavigationDestination.self) {
                    switch $0 {
                    case .chat(let chatRoom):
                        ChatView(chatRoom: chatRoom)
                    case .search:
                        SearchView()
                    }
                }
        }
    }
}

#Preview {
    let navigationRouter: NavigationRouter = .init()
    
    return LMessengerNavigationStackView {
        Text("test")
    }
    .environmentObject(navigationRouter)
}
