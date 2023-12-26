//
//  DIContainer.swift
//  LMessenger
//
//  Created by Choi Oliver on 2023/11/29.
//

import Foundation

class DIContainer: ObservableObject {
    // service
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
