//
//  PokemonResponse.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation

struct PokemonResponse: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeEntry]
    let stats: [PokemonStatEntry]
}

struct Sprites: Decodable {
    let frontDefault: String?
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeEntry: Decodable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Decodable {
    let name: String
}

struct PokemonStatEntry: Decodable {
    let baseStat: Int
    let stat: StatInfo

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatInfo: Decodable {
    let name: String
}

struct PokemonListResponse: Decodable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
}

// MARK: - Domain Models

struct Pokemon {
    let id: Int
    let name: String
    let imageUrl: String?
    let types: [String]


    init(from response: PokemonResponse) {
        self.id = response.id
        self.name = response.name.capitalized
        self.imageUrl = response.sprites.frontDefault
        self.types = response.types.map { $0.type.name.capitalized }
    }

    static func stats(from response: PokemonResponse) -> PokemonStats {
        var hp = 0, atk = 0, def = 0, spAtk = 0, spDef = 0, spd = 0

        for entry in response.stats {
            switch entry.stat.name.lowercased() {
            case "hp": hp = entry.baseStat
            case "attack": atk = entry.baseStat
            case "defense": def = entry.baseStat
            case "special-attack": spAtk = entry.baseStat
            case "special-defense": spDef = entry.baseStat
            case "speed": spd = entry.baseStat
            default: break
            }
        }
        return PokemonStats(hp: hp, attack: atk, defense: def, spAttack: spAtk, spDefense: spDef, speed: spd)
    }
}

struct PokemonStats {
    let hp: Int
    let attack: Int
    let defense: Int
    let spAttack: Int
    let spDefense: Int
    let speed: Int
}
