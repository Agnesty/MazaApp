//
//  TrendingViewModel.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 07/09/25.
//

import Combine
import Foundation

final class TrendingViewModel: ObservableObject {
    static let shared = TrendingViewModel()

    private let repository: TrendingRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    // State
    let productResponse = CurrentValueSubject<[ProductResponse], Never>([])
    let products = CurrentValueSubject<[Int: [Product]], Never>([:])
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let errorMessage = PassthroughSubject<String, Never>()

    init(repository: TrendingRepositoryProtocol = TrendingRepositoryService()) {
        self.repository = repository
    }

    func allCallTrendingAPI() {
        fetchTrendingProducts()
    }

    func products(for id: Int) -> [Product] {
        return products.value[id] ?? []
    }

    func fetchTrendingProducts() {
        isLoading.send(true)

        repository.fetchTrendingProducts()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading.send(false)
                    if case let .failure(error) = completion {
                        self?.errorMessage.send(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] responses in
                    guard let self = self else { return }
                    self.productResponse.send(responses)
                    let dict = Dictionary(uniqueKeysWithValues: responses.map { ($0.id, $0.products) })
                    self.products.send(dict)
                }
            )
            .store(in: &cancellables)
    }
}
