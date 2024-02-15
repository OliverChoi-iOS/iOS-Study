//
//  ProductDetailResponse.swift
//  CProject
//
//  Created by Choi Oliver on 2/15/24.
//

import Foundation

struct ProductDetailResponse: Decodable {
    let bannerImages: [String]
    let product: ProductDetail
    let option: ProductDetailOption
    let detailImages: [String]
}

struct ProductDetail: Decodable {
    let name: String
    let discountPercent: Int
    let originalPrice: Int
    let discountPrice: Int
    let rate: Int
}

struct ProductDetailOption: Decodable {
    let type: String
    let name: String
    let image: String
}
