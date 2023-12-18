//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/18/23.
//

import Foundation
import Combine
import FirebaseDatabase

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    
}

class UserDBRepository: UserDBRepositoryType {
    
    var db: DatabaseReference = Database.database().reference()
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object > data > dic
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) } // object > data
            .compactMap { try? JSONSerialization.jsonObject(with: $0,options: .fragmentsAllowed) } // data > dic
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    // save in Users/{user id}/ ..
                    self?.db
                        .child(DBKey.Users)
                        .child(object.id)
                        .setValue(value, withCompletionBlock: { error, _ in
                            if let error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        })
                }
            }
            .mapError({ DBError.error($0) })
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db
                .child(DBKey.Users)
                .child(userId)
                .getData(completion: { error, snapshot in
                    if let error {
                        promise(.failure(DBError.error(error)))
                    } else if snapshot?.value is NSNull {
                        promise(.success(nil))
                    } else {
                        promise(.success(snapshot?.value))
                    }
                })
        }.flatMap { value in
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: UserObject.self, decoder: JSONDecoder())
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: .emptyValue).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}
