//
//  ProductRepositoryProtocol.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 04/09/25.
//

import Foundation
import RxSwift

protocol HomeRepositoryProtocol {
    func fetchProducts() -> Observable<[ProductResponse]>
    func fetchProductDetail(id: Int) -> Observable<ProductResponse>
    func fetchHomeData() -> Observable<HomeResponse>
}
