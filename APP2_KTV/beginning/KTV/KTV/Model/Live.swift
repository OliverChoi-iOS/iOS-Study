//
//  Live.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/17.
//

import Foundation

// MARK: - Live
struct Live: Decodable {
    let list: [Item]
}

extension Live {
    struct Item: Decodable {
        let videoId: Int
        let thumbnailUrl: URL
        let title: String
        let channel: String
    }
}
