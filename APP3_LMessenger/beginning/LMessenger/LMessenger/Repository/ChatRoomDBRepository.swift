//
//  ChatRoomDBRepository.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation
import Combine
import FirebaseDatabase

protocol ChatRoomDBRepositoryType {
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError>
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError>
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError>

    /// 1. other user 쪽에도 채팅방 생성 (ChatRooms/{other user id}/{my user id}/
    /// 2. last message update (내 채팅방, 상대 채팅방 모두)
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    private let reference: DBReferenceType
    
    init(reference: DBReferenceType) {
        self.reference = reference
    }
    
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        reference.fetch(key: DBKey.ChatRooms, path: "\(myUserId)/\(otherUserId)")
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: ChatRoomObject?.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    return Just(nil)
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { [weak self] value in
                guard let self else {
                    return Fail<Void, DBError>(error: .selfIsNil).eraseToAnyPublisher()
                }
                
                return self.reference.setValue(key: DBKey.ChatRooms, path: "\(myUserId)/\(object.otherUserId)", value: value)
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        reference.fetch(key: DBKey.ChatRooms, path: myUserId)
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] { // {"otherUserId": {k: v}}
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: ChatRoomObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as ChatRoomObject } }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([])
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: DBError.invalidatedType)
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError> {
        let values = [
            "\(DBKey.ChatRooms)/\(myUserId)/\(otherUserId)/lastMessage": lastMessage,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/lastMessage": lastMessage,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/chatRoomId": chatRoomId,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/otherUserName": myUserName,
            "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/otherUserId": myUserId
        ]
        
        return reference.setValues(values)
    }
}
