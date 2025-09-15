//
//  LiveViewModel.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LiveViewModel {
    static let shared = LiveViewModel()
    private let repository: LiveRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    let videos = BehaviorRelay<[PexelsVideo]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<String>()
    
    init(repository: LiveRepositoryProtocol = LiveRepositoryService.shared) {
        self.repository = repository
    }
    
    func fetchAllAPI() {
        fetchVideos()
    }
    
    func fetchVideos() {
        isLoading.accept(true)
        repository.fetchPopularVideos()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] videos in
                self?.videos.accept(videos)
                self?.isLoading.accept(false)
            } onError: { [weak self] err in
                self?.error.accept(err.localizedDescription)
                self?.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
