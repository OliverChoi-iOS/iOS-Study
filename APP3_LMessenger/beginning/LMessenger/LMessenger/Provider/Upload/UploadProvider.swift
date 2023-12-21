//
//  UploadProvider.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseStorageCombineSwift

protocol UploadProviderType {
    func upload(path: String, data: Data, fileName: String) async throws -> URL
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError>
}

class UploadProvider: UploadProviderType {
    let storageRef = Storage.storage().reference()
    
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = storageRef.child(path).child(fileName)
        let _ = try await ref.putDataAsync(data)
        let url = try await ref.downloadURL()
        
        return url
    }
    
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError> {
        let ref = storageRef.child(path).child(fileName)
        
        return ref.putData(data)
            .flatMap { _ in
                ref.downloadURL()
            }
            .mapError { UploadError.error($0) }
            .eraseToAnyPublisher()
    }
}
