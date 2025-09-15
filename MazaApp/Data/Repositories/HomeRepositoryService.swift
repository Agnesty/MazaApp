//
//  File.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 25/08/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeRepositoryService: HomeRepositoryProtocol {
    func fetchHomeData() -> Observable<HomeResponse> {
        return APIClient.shared.request(.getHomeData, type: HomeResponse.self)
    }
    
    func fetchProducts() -> Observable<[ProductResponse]> {
        return APIClient.shared.request(.getProducts, type: [ProductResponse].self)
            .do(onNext: { response in
                print("✅ Products decoded: \(response)")
            }, onError: { error in
                print("❌ Error decoding products: \(error)")
            })
    }
    
    func fetchProductDetail(id: Int) -> Observable<ProductResponse> {
        return APIClient.shared.request(.getProductDetail(id: id), type: ProductResponse.self)
            .do(
                onNext: { product in
                    print("✅ Product fetched:", product)
                },
                onError: { error in
                    print("❌ fetchProductDetail error:", error)
                }
            )
    }
}
