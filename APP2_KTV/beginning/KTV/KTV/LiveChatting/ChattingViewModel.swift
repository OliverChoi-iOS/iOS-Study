//
//  ChattingViewModel.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/24.
//

import Foundation

@MainActor class ChattingViewModel {
    private let chatSimulator = ChatSimulator()
    var chatReceived: (() -> Void)?
    private(set) var messages: [ChatMessage] = []
    
    init() {
        self.chatSimulator.setMessageHandler { [weak self] messages in
            guard let self else { return }
            
            self.messages.append(messages)
            self.chatReceived?()
        }
    }
    
    func start() {
        self.chatSimulator.start()
    }
    
    func stop() {
        self.chatSimulator.stop()
    }
    
    func sendMessage(_ message: String) {
        self.chatSimulator.sendMessage(message)
    }
}
