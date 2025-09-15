//
//  APIError.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 25/08/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case decoding
    case network(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: 
            return "URL tidak valid"
        case .decoding: 
            return "Gagal parsing data"
        case .network(let err): 
            return "Jaringan bermasalah: \(err.localizedDescription)"
        case .unknown: 
            return "Kesalahan tidak diketahui"
        }
    }
}
