//
//  PokemonRepositoryService.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation
import RxSwift

final class PokemonRepositoryService: PokemonRepositoryProtocol {
    func fetchPokemons(limit: Int, offset: Int) -> Observable<[Pokemon]> {
        return APIClient.shared.request(.getPokemons(limit: limit, offset: offset), type: PokemonListResponse.self)
            .flatMap { listResponse -> Observable<[Pokemon]> in
                let requests = listResponse.results.map { item -> Observable<Pokemon> in
                    return APIClient.shared.request(.custom(urlString: item.url), type: PokemonResponse.self)
                        .map { Pokemon(from: $0) }
                }
                return Observable.zip(requests)
            }
    }

    func fetchPokemonDetail(id: Int) -> Observable<(Pokemon, PokemonStats)> {
        return APIClient.shared.request(.getPokemonDetail(id: id), type: PokemonResponse.self)
            .map { response in
                let pokemon = Pokemon(from: response)
                let stats = Pokemon.stats(from: response)
                return (pokemon, stats)
            }
    }
}

