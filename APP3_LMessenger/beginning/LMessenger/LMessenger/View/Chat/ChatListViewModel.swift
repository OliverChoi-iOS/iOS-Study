//
//  ChatListViewModel.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    enum Action {
        case load
    }
    
    @Published var chatRooms: [ChatRoom] = []
    
    let userId: String
    
    private var container: DIContainer
    private var navigationRouter: NavigationRouter
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        navigationRouter: NavigationRouter,
        userId: String
    ) {
        self.container = container
        self.navigationRouter = navigationRouter
        self.userId = userId
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            container.services.chatRoomService.loadChatRooms(myUserId: userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] chatRooms in
                    self?.chatRooms = chatRooms
                }.store(in: &subscriptions)

        }
    }
}
