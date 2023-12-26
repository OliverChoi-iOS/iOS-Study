//
//  DIContainer.swift
//  LMessenger
//
//  Created by Choi Oliver on 2023/11/29.
//

import Foundation

protocol DIContainable {
    var services: ServiceType { get set }
    var searchDataController: DataControllable { get set }
    var navigationRouter: NavigationRoutable & ObservableObjectSettable { get set }
    var appearanceController: AppearanceControllable & ObservableObjectSettable { get set }
}

class DIContainer: DIContainable, ObservableObject {
    // service
    var services: ServiceType
    var searchDataController: DataControllable
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    var appearanceController: AppearanceControllable & ObservableObjectSettable
    
    init(
        services: ServiceType,
        searchDataController: DataControllable = SearchDataController(),
        navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter(),
        appearanceController: AppearanceControllable & ObservableObjectSettable = AppearanceController()
    ) {
        self.services = services
        self.searchDataController = searchDataController
        self.navigationRouter = navigationRouter
        self.appearanceController = appearanceController
        
        self.navigationRouter.setObjectWillChange(objectWillChange)
        self.appearanceController.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubService())
    }
}
