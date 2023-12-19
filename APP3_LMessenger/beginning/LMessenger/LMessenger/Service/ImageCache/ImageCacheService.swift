//
//  ImageCacheService.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

class ImageCacheService: ImageCacheServiceType {
    let memoryStoarge: MemoryStorageType
    let diskStorage: DiskStorageType
    
    init(memoryStoarge: MemoryStorageType, diskStorageType: DiskStorageType) {
        self.memoryStoarge = memoryStoarge
        self.diskStorage = diskStorageType
    }
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        /*
         1. memory storage
         2. disk storage
         3. url session
         */
        imageWithMemoryCache(for: key)
            .flatMap { [weak self] image -> AnyPublisher<UIImage?, Never> in
                if let image {
                    return Just(image).eraseToAnyPublisher()
                } else {
                    return self?.imageWithDiskCache(for: key).eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image = self?.memoryStoarge.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        .flatMap { [weak self] image -> AnyPublisher<UIImage?, Never> in
            if let image {
                return Just(image)
                    .handleEvents(receiveOutput: { [weak self] image in
                        guard let image else { return }
                        
                        self?.store(for: key, image: image, toDisk: false)
                    })
                    .eraseToAnyPublisher()
            } else {
                return self?.remoteImage(for: key) ?? Empty().eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else { return }
                
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    func store(for key: String, image: UIImage, toDisk: Bool) {
        memoryStoarge.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}

class StubImageCacheService: ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
