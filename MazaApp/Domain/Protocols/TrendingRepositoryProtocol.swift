//
//  TrendingRepositoryProtocol.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 07/09/25.
//

import Foundation
import Combine

protocol TrendingRepositoryProtocol {
    func fetchTrendingProducts() -> AnyPublisher<[ProductResponse], Error>
    func fetchTrendingData() -> AnyPublisher<HomeResponse, Error>
}
