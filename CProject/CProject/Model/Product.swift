//
//  Product.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
    let discount: String
    let originalPrice: Int
    let discountPrice: Int
}
