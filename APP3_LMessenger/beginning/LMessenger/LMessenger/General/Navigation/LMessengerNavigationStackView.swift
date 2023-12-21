//
//  LMessengerNavigationStackView.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import SwiftUI

struct LMessengerNavigationStackView<Content: View>: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var content: Content
    
    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navigationRouter.destinations) {
            content
                .navigationDestination(for: NavigationDestination.self) {
                    switch $0 {
                    case let .chat(chatRoomId, myUserId, otherUserId):
                        ChatView(
                            viewModel: .init(
                                container: container,
                                chatRoomId: chatRoomId,
                                myUserId: myUserId,
                                otherUserId: otherUserId
                            )
                        )
                    case let .search(myUserId):
                        SearchView(
                            viewModel: .init(container: container, userId: myUserId)
                        )
                    }
                }
        }
    }
}

#Preview {
    let container: DIContainer = .init(services: StubService())
    let navigationRouter: NavigationRouter = .init()
    
    return LMessengerNavigationStackView {
        Text("test")
    }
    .environmentObject(container)
    .environmentObject(navigationRouter)
}
