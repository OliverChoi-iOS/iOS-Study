//
//  ObservableObjectSettable.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/26/23.
//

import Foundation
import Combine

protocol ObservableObjectSettable: AnyObject {
    var objectWillChange: ObservableObjectPublisher? { get set }
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher)
}

extension ObservableObjectSettable {
    
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher) {
        self.objectWillChange = objectWillChange
    }
}
