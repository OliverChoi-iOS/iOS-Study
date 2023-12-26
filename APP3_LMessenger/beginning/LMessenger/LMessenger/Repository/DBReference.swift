//
//  DBReference.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/26/23.
//

import Foundation
import Combine
import FirebaseDatabase

protocol DBReferenceType {
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError>
    func setValue(key: String, path: String?, value: Any) async throws
    func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError>
    func fetch() -> AnyPublisher<Any?, DBError>
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func fetch(key: String, path: String?) async throws -> Any?
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError>
    func childByAutoId(key: String, path: String?) -> String?
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func removeObservedHandlers()
}

class DBReference: DBReferenceType {
    
    var db: DatabaseReference = Database.database().reference()
    
    var observedHandlers: [UInt] = []
    
    private func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
    
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Void, DBError> { [weak self] promise in
            // save in Users/{user id}/ ..
            self?.db
                .child(path)
                .setValue(value, withCompletionBlock: { error, _ in
                    if let error {
                        promise(.failure(DBError.error(error)))
                    } else {
                        promise(.success(()))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
    
    func setValue(key: String, path: String?, value: Any) async throws {
        let path = getPath(key: key, path: path)
        
        try await self.db
            .child(path)
            .setValue(value)
    }
    
    func setValues(_ values: [String : Any]) -> AnyPublisher<Void, DBError> {
        Future { [weak self] promise in
            self?.db
                .updateChildValues(values, withCompletionBlock: { error, _ in
                    if let error {
                        promise(.failure(DBError.error(error)))
                    } else {
                        promise(.success(()))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
    
    func fetch() -> AnyPublisher<Any?, DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db
                .child(DBKey.Users)
                .getData(completion: { error, snapshot in
                    if let error {
                        promise(.failure(DBError.error(error)))
                    } else if snapshot?.value is NSNull {
                        promise(.success(nil))
                    } else {
                        promise(.success(snapshot?.value))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Any?, DBError> { [weak self] promise in
            self?.db
                .child(path)
                .getData(completion: { error, snapshot in
                    if let error {
                        promise(.failure(DBError.error(error)))
                    } else if snapshot?.value is NSNull {
                        promise(.success(nil))
                    } else {
                        promise(.success(snapshot?.value))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) async throws -> Any? {
        let path = getPath(key: key, path: path)
        
        return try await self.db
            .child(path)
            .getData()
            .value
    }
    
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Any?, DBError> { [weak self] promise in
            self?.db
                .child(path)
                .queryOrdered(byChild: orderedName)
                .queryStarting(atValue: queryString)
                .queryEnding(atValue: queryString + "\u{f8ff}")
                .observeSingleEvent(
                    of: .value,
                    with: { snapshot in
                        if snapshot.value is NSNull {
                            promise(.success(nil))
                        } else {
                            promise(.success(snapshot.value))
                        }
                    },
                    withCancel: { error in
                        promise(.failure(DBError.error(error)))
                    }
                ) // [String: [String: Any]]
        }
        .eraseToAnyPublisher()
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        let path = getPath(key: key, path: path)
        
        let ref = db
            .child(path)
            .childByAutoId()
        
        return ref.key
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        // maintain stream
        let subject = PassthroughSubject<Any?, DBError>()
        
        let handler = db
            .child(path)
            .observe(.childAdded) { snapshot in
                subject.send(snapshot.value)
            }
        
        observedHandlers.append(handler)
        
        return subject.eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        observedHandlers.forEach { [weak self] handler in
            self?.db.removeObserver(withHandle: handler)
        }
    }
}
