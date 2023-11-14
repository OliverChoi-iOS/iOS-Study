//
//  VideoListItem.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import Foundation

struct VideoListItem: Decodable {
    let imageUrl: URL
    let title: String
    let playtime: Double
    let channel: String
    var videoId: Int
}
