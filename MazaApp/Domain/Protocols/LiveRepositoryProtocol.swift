//
//  LiveRepositoryProtocol.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation
import RxSwift

protocol LiveRepositoryProtocol {
    func fetchPopularVideos() -> Observable<[PexelsVideo]>
}
