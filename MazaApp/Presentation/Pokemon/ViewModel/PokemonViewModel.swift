//
//  PokemonViewModel.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PokemonViewModel {
    static let shared = PokemonViewModel()
    private let repository: PokemonRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    let pokemons = BehaviorSubject<[Pokemon]>(value: [])
    let filteredPokemons = BehaviorSubject<[Pokemon]>(value: [])
    let isLoading = BehaviorSubject<Bool>(value: false)
    let error = PublishSubject<String>()
    
    let searchQuery = BehaviorSubject<String>(value: "")
    
    //Paging
    private var currentOffset: Int = 0
    private let pageSize: Int = 20
    private var isLastPage = false
    
    init(repository: PokemonRepositoryProtocol = PokemonRepositoryService()) {
        self.repository = repository
        setupBindings()
    }
    
    func callAllAPI() {
        resetPaging()
        loadPokemons()
    }
    
    private func setupBindings() {
        Observable.combineLatest(pokemons, searchQuery)
            .map { pokemons, query in
                guard !query.isEmpty else { return pokemons }
                return pokemons.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
            .bind(to: filteredPokemons)
            .disposed(by: disposeBag)
    }
    
    private func resetPaging() {
        currentOffset = 0
        isLastPage = false
        pokemons.onNext([])
    }
    
    func loadPokemons(limit: Int = 20, offset: Int = 0) {
        guard !(try? isLoading.value())! else { return }
        guard !isLastPage else { return }
        
        isLoading.onNext(true)
        repository.fetchPokemons(limit: limit, offset: offset)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] data in
                    guard let self = self else { return }
                    var currentData = (try? self.pokemons.value()) ?? []
                    
                    if data.isEmpty {
                        self.isLastPage = true
                    } else {
                        currentData.append(contentsOf: data)
                        self.pokemons.onNext(currentData)
                        self.currentOffset += limit
                    }
                    
                    self.isLoading.onNext(false)
                },
                onError: { [weak self] err in
                    self?.error.onNext(err.localizedDescription)
                    self?.isLoading.onNext(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadMorePokemons() {
        loadPokemons(limit: pageSize, offset: currentOffset)
    }
    
    func fetchDetail(for id: Int) -> Observable<(Pokemon, PokemonStats)> {
        return repository.fetchPokemonDetail(id: id)
    }
    
}
