//
//  HomeModalDestination.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String)
    case setting
    
    var id: Int {
        hashValue
    }
}
