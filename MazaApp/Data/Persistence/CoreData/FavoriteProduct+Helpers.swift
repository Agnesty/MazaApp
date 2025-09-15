//
//  FavoriteProduct+Helpers.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 09/09/25.
//

import Foundation

extension FavoriteProduct {
    func toProduct() -> Product {
        return Product(
            id: Int(self.id),
            imageName: self.imageName ?? "",
            imageURL: self.imageURL ?? "",
            discountPercentage: self.discountPercentage ?? "",
            productName: self.productName ?? "",
            priceAfterDiscount: Int(self.priceAfterDiscount),
            originalPrice: Int(self.originalPrice),
            promoText: self.promoText ?? "",
            ratingText: self.ratingText ?? "",
            storeName: self.storeName ?? "",
            description: self.productDescription ?? ""
        )
    }
}
