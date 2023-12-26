//
//  SearchDataController.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/21/23.
//

import Foundation
import CoreData

protocol DataControllable {
    var persistantContainer: NSPersistentContainer { get set }
}

class SearchDataController: DataControllable {
    var persistantContainer = NSPersistentContainer(name: "Search")
    
    init() {
        persistantContainer.loadPersistentStores { description, error in
            if let error {
                print("Core Data Failed: ", error)
            }
        }
    }
}
