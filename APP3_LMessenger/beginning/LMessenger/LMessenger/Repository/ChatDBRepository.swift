//
//  ChatDBRepository.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation
import Combine

protocol ChatDBRepositoryType {
    func addChat(_ object: ChatObject, id chatRoomId: String) -> AnyPublisher<Void, DBError>
    func childByAutoId(chatRoomId: String) -> String
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError>
    func removeObservedHandlers() -> Void
}

class ChatDBRepository: ChatDBRepositoryType {
    
    private let reference: DBReferenceType
    
    init(reference: DBReferenceType) {
        self.reference = reference
    }
    
    func addChat(_ object: ChatObject, id chatRoomId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { [weak self] value in
                guard let self else {
                    return Fail<Void, DBError>(error: .selfIsNil).eraseToAnyPublisher()
                }
                
                return reference.setValue(key: DBKey.Chats, path: "\(chatRoomId)/\(object.chatId)", value: value)
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func childByAutoId(chatRoomId: String) -> String {
        reference.childByAutoId(key: DBKey.Chats, path: chatRoomId) ?? ""
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError> {
        
        return reference.observeChildAdded(key: DBKey.Chats, path: chatRoomId)
            .flatMap { value in
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: ChatObject?.self, decoder: JSONDecoder())
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
    
    func removeObservedHandlers() {
        reference.removeObservedHandlers()
    }
}
