//
//  RecommendationProductProfile.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 26/07/25.
//

import Foundation

struct ProductResponse: Codable {
    let id: Int
    let productSource: String
    let products: [Product]
}

// MARK: - Product Model
struct Product: Codable {
    let id: Int
    let imageName: String
    let imageURL: String
    let discountPercentage: String
    let productName: String
    let priceAfterDiscount: Int
    let originalPrice: Int
    let promoText: String
    let ratingText: String
    let storeName: String
    let description: String
}
