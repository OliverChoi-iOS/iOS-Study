//
//  Chat.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation

struct Chat: Hashable, Identifiable {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
    
    var id: String { chatId }
}

extension Chat {
    func toObject() -> ChatObject {
        .init(
            chatId: chatId,
            userId: userId,
            message: message,
            photoURL: photoURL,
            date: date.timeIntervalSince1970
        )
    }
}

extension Chat {
    static var stub1: Chat {
        .init(chatId: "chat1_id", userId: "user1_id", message: "안녕하세요", date: Date())
    }
    static var stub2: Chat {
        .init(chatId: "chat1_id", userId: "user2_id", message: "안녕하세요", date: Date())
    }
}
