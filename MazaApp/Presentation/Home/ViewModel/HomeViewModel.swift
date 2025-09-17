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
    let visibleProducts = BehaviorRelay<[Int: [Product]]>(value: [:])
    private var productOffsets: [Int: Int] = [:]

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
                    
                    for (categoryId, _) in dict {
                        self.loadInitialProducts(for: categoryId, pageSizeProduct: 4)
                    }
                    
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
    
    func loadInitialProducts(for categoryId: Int, pageSizeProduct: Int = 4) {
        guard let all = products.value[categoryId] else { return }
        let slice = Array(all.prefix(pageSizeProduct))
        visibleProducts.accept(visibleProducts.value.merging([categoryId: slice]) { _, new in new })
        productOffsets[categoryId] = slice.count
        print("🔎 [Initial] Category \(categoryId) → ambil \(slice.count) produk pertama")
    }
    
//    func loadMoreProducts(for categoryId: Int, pageSize: Int = 4) {
//        guard let all = products.value[categoryId] else { return }
//        let currentOffset = productOffsets[categoryId] ?? 0
//        guard currentOffset < all.count else { return } // habis
//
//        let nextOffset = min(currentOffset + pageSize, all.count)
//        let slice = Array(all.prefix(nextOffset))
//        visibleProducts.accept(visibleProducts.value.merging([categoryId: slice]) { _, new in new })
//        productOffsets[categoryId] = nextOffset
//        print("isi produk load more: ",slice.count)
//    }
    
    func loadMoreProducts(for categoryId: Int, pageSize: Int = 4) {
        guard let all = products.value[categoryId] else { return }
        let currentOffset = productOffsets[categoryId] ?? 0
        guard currentOffset < all.count else { return } // sudah habis

        let nextOffset = min(currentOffset + pageSize, all.count)
        let newSlice = Array(all[currentOffset..<nextOffset])

        var updated = visibleProducts.value[categoryId] ?? []
        updated.append(contentsOf: newSlice)

        visibleProducts.accept(visibleProducts.value.merging([categoryId: updated]) { _, new in new })
        productOffsets[categoryId] = nextOffset
        print("🔎 [LoadMore] Category \(categoryId) → tambah \(newSlice.count), total sekarang \(updated.count)")
    }
}
