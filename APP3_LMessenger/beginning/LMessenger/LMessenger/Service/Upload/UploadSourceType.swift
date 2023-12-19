//
//  UploadSourceType.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation

enum UploadSourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    var path: String {
        switch self {
        case let .chat(chatRoomId): // Chats/{chat room id}
            return "\(DBKey.Chats)/\(chatRoomId)"
        case let .profile(userId): // Users/{user id}
            return "\(DBKey.Users)/\(userId)"
        }
    }
}
