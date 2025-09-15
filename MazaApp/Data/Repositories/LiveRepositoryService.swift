//
//  LiveRepositoryService.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation
import RxSwift

final class LiveRepositoryService: LiveRepositoryProtocol {
    static let shared = LiveRepositoryService()
    private init() {}
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["PEXELS_API_KEY"] as? String else {
            fatalError("Missing API Key")
        }
        return key
    }
    
    func fetchPopularVideos() -> Observable<[PexelsVideo]> {
        let endpoint = APIEndpoint.custom(urlString: "https://api.pexels.com/videos/popular?per_page=10&page=1",
                                         headers: ["Authorization": apiKey])
        return APIClient.shared.request(endpoint, type: PexelsVideoResponse.self)
            .map { $0.videos }
    }
}
