//
//  Bookmark.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import Foundation

struct Bookmark: Decodable {
    
    let channels: [Item]
}

extension Bookmark {
    
    struct Item: Decodable {
        let channel: String
        let channelId: Int
        let thumbnail: URL
    }
}
