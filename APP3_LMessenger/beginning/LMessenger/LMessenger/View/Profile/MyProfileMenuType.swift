//
//  MyProfileMenuType.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/19/23.
//

import Foundation

enum MyProfileMenuType: Hashable, CaseIterable {
    case studio
    case decorate
    case keep
    case story
    
    var description: String {
        switch self {
        case .studio:
            "스튜디오"
        case .decorate:
            "꾸미기"
        case .keep:
            "Keep"
        case .story:
            "스토리"
        }
    }
    
    var imageName: String {
        switch self {
        case .studio:
            "mood"
        case .decorate:
            "palette"
        case .keep:
            "bookmark_profile"
        case .story:
            "play_circle"
        }
    }
}
