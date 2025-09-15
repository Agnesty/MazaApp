//
//  PokemonRepositoryProtocol.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation
import RxSwift

protocol PokemonRepositoryProtocol {
    func fetchPokemons(limit: Int, offset: Int) -> Observable<[Pokemon]>
    func fetchPokemonDetail(id: Int) -> Observable<(Pokemon, PokemonStats)>
}
