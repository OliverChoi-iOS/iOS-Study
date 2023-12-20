//
//  NavigationRouter.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation

class NavigationRouter: ObservableObject {
    @Published var destinations: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
        _ = destinations.popLast()
    }
    
    func popToRootView() {
        destinations = []
    }
}
