//
//  NavigationDestination.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation

enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, otherUserId: String)
    case search
}
