//
//  TrendingRepositoryService.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 07/09/25.
//

import Foundation
import Combine

final class TrendingRepositoryService: TrendingRepositoryProtocol {
    func fetchTrendingProducts() -> AnyPublisher<[ProductResponse], Error> {
        return APIClient.shared.requestWithCombine(.getProducts, type: [ProductResponse].self)
    }

    func fetchTrendingData() -> AnyPublisher<HomeResponse, Error> {
        return APIClient.shared.requestWithCombine(.getHomeData, type: HomeResponse.self)
    }
}
