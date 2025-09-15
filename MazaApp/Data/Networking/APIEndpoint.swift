//
//  APIEndpoint.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 25/08/25.
//

import Foundation

enum APIEndpoint {
    case getProducts
    case getProductDetail(id: Int)
    case getHomeData
    case getPokemons(limit: Int, offset: Int)
    case getPokemonDetail(id: Int)
    case custom(urlString: String, headers: [String: String]? = nil)
    
    var urlRequest: URLRequest {
        let baseURL = URL(string: "http://localhost:3002")!
        var pokemonURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        var pokemonURLwithQuery = URLComponents(string: "https://pokeapi.co/api/v2/pokemon?")!
        switch self {
        case .getProducts:
            let url = baseURL.appendingPathComponent("/product-data")
            return URLRequest(url: url)
        case .getProductDetail(let id):
            let url = baseURL.appendingPathComponent("/product-data/\(id)")
            return URLRequest(url: url)
        case .getHomeData:
            let url = baseURL.appendingPathComponent("/home-data")
            return URLRequest(url: url)
        case .getPokemons(let limit, let offset):
            pokemonURLwithQuery.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            return URLRequest(url: pokemonURLwithQuery.url!)
        case .getPokemonDetail(let id):
            let url = pokemonURL.appendingPathComponent("/\(id)/")
            return URLRequest(url: url)
        case .custom(let urlString, let headers):
            var request = URLRequest(url: URL(string: urlString)!)
            headers?.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        }
    }
}
