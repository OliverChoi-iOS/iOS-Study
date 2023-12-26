//
//  URLImageViewModel.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import UIKit
import Combine

class URLImageViewModel: ObservableObject {
    
    var loadingOrSuccess: Bool {
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var loading: Bool = false
    private var container: DIContainable
    private var urlString: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainable, urlString: String) {
        self.container = container
        self.urlString = urlString
    }
    
    func start() {
        guard !urlString.isEmpty else { return }
        
        loading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }.store(in: &subscriptions)
    }
}
