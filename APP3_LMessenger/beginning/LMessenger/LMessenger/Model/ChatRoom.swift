//
//  ChatRoom.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation

struct ChatRoom: Hashable {
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUserId: String
}

extension ChatRoom {
    func toObject() -> ChatRoomObject {
        .init(
            chatRoomId: chatRoomId,
            lastMessage: lastMessage,
            otherUserName: otherUserName,
            otherUserId: otherUserId
        )
    }
}

extension ChatRoom {
    static var stub1: ChatRoom {
        .init(chatRoomId: "chatRoom1_id", otherUserName: "김땡땡", otherUserId: "user2_id")
    }
    static var stub2: ChatRoom {
        .init(chatRoomId: "chatRoom2_id", lastMessage: "테스트", otherUserName: "이땡땡", otherUserId: "user3_id")
    }
}
