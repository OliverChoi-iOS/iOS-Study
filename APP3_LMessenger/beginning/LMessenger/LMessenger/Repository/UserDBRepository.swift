//
//  UserDBRepository.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/18/23.
//

import Foundation
import Combine

protocol UserDBRepositoryType {
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    func getUser(userId: String) async throws -> UserObject
    func updateUser(userId: String, key: String, value: Any) async throws
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError>
}

class UserDBRepository: UserDBRepositoryType {
    
    private let reference: DBReferenceType
    
    init(reference: DBReferenceType) {
        self.reference = reference
    }
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object > data > dic
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) } // object > data
            .compactMap { try? JSONSerialization.jsonObject(with: $0,options: .fragmentsAllowed) } // data > dic
            .flatMap { [weak self] value in
                guard let self else {
                    return Fail<Void, DBError>(error:
                        .selfIsNil).eraseToAnyPublisher()
                }
                
                return reference.setValue(key: DBKey.Users, path: object.id, value: value)
            }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        reference.fetch(key: DBKey.Users, path: userId)
            .flatMap { value in
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
    
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await reference.fetch(key: DBKey.Users, path: userId)
        else {
            throw DBError.emptyValue
        }
        
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        
        return userObject
    }
    
    func updateUser(userId: String, key: String, value: Any) async throws {
        let path = "\(userId)/\(key)"
        
        try await reference.setValue(key: DBKey.Users, path: path, value: value)
    }
    
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        reference.fetch()
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject } }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([])
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidatedType).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        Publishers.Zip(users.publisher, users.publisher)
            .compactMap { origin, converted in
                if let converted = try? JSONEncoder().encode(converted) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .compactMap { origin, converted in
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
            .flatMap { [weak self] origin, converted in
                guard let self else {
                    return Fail<Void, DBError>(error: .selfIsNil).eraseToAnyPublisher()
                }
                
                return reference.setValue(key: DBKey.Users, path: origin.id, value: converted)
            }
            .last()
            .eraseToAnyPublisher()
    }
    
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError> {
        reference.filter(key: DBKey.Users, path: nil, orderedName: "name", queryString: queryString)
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject } }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([])
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidatedType).eraseToAnyPublisher()
                }
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
}
