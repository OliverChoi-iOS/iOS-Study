//
//  ChatData.swift
//  LMessenger
//
//  Created by Choi Oliver on 12/20/23.
//

import Foundation

struct ChatData: Hashable, Identifiable {
    var dateStr: String
    var chats: [Chat]
    
    var id: String { dateStr }
}
