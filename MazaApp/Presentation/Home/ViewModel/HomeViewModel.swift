//
//  HomeViewModel.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 04/09/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    static let shared = HomeViewModel()
    
    // MARK: - Properties
    private let repository: HomeRepositoryProtocol
    private let disposeBag = DisposeBag()

    let historyRelay = BehaviorRelay<[String]>(value: [])
    let searchResult = BehaviorRelay<[Product]>(value: [])
    let homeData = BehaviorRelay<HomeResponse?>(value: nil)
    let productResponse = BehaviorRelay<[ProductResponse]>(value: [])
    let products = BehaviorRelay<[Int: [Product]]>(value: [:])

    let showHomeSkeleton = BehaviorRelay<Bool>(value: false)
    let showHomeSearchSkeleton = BehaviorRelay<Bool>(value: false)
    let showProductDetailSkeleton = BehaviorRelay<Bool>(value: false)
    
    let selectedProduct = PublishRelay<ProductResponse>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    // MARK: - Init
    init(repository: HomeRepositoryProtocol = HomeRepositoryService()) {
        self.repository = repository
    }
    
    func allCallHomeAPI() {
        fetchProducts()
        //fetchProductDetail(id: <#T##Int#>)
        fetchHomeData()
    }
    
    func products(for id: Int) -> [Product] {
        return products.value[id] ?? []
    }
    
    // MARK: - Actions
    func fetchProducts() {
        isLoading.accept(true)
        
        repository.fetchProducts()
            .subscribe(
                onNext: { [weak self] products in
                    guard let self = self else { return }
                    self.productResponse.accept(products)
    
                    let dict = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0.products) })
                    self.products.accept(dict)
                    self.isLoading.accept(false)
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchProductDetail(id: Int) {
        showProductDetailSkeleton.accept(true)
        for (sourceId, productsArray) in products.value {
            if let product = productsArray.first(where: { $0.id == id }) {
                
                let productSource = "recommendation"
                
                let productResponse = ProductResponse(
                    id: sourceId,
                    productSource: productSource,
                    products: [product] 
                )
                
                selectedProduct.accept(productResponse)
                showProductDetailSkeleton.accept(false)
                return
            }
        }
        errorMessage.accept("Product not found")
        showProductDetailSkeleton.accept(false)
    }
    
    func fetchHomeData() {
        repository.fetchHomeData()
            .subscribe(
                onNext: { [weak self] homeData in
                    self?.homeData.accept(homeData)
                },
                onError: { [weak self] error in
                    self?.errorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func searchProducts(keyword: String) {
        guard !keyword.isEmpty else {
            searchResult.accept([])
            return
        }
        let allProducts = products.value.values.flatMap { $0 }
        
        let filtered = allProducts.filter { product in
            product.productName.localizedCaseInsensitiveContains(keyword)
        }
        searchResult.accept(filtered)
    }
}
