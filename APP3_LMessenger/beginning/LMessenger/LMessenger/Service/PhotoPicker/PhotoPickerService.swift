//
//  PhotoPickerService.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine

enum PhotoPickerError: Error {
    case importFailed
}

protocol PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError>
}

class PhotoPickerService: PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
            throw PhotoPickerError.importFailed
        }
        
        return image.data
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Future { promise in
            imageSelection.loadTransferable(type: PhotoImage.self) { result in
                switch result {
                case .success(let image):
                    guard let imageData = image?.data else {
                        promise(.failure(PhotoPickerError.importFailed))
                        return
                    }
                    
                    promise(.success(imageData))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .mapError { ServiceError.error($0) }
        .eraseToAnyPublisher()
    }
}

class StubPhotoPickerService: PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        Data()
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Just(Data())
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}
