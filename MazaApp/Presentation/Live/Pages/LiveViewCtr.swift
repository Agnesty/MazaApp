//
//  LiveViewCtr().swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import RxSwift
import RxCocoa

class LiveViewCtr: BaseViewController {
    
    private let viewModel = LiveViewModel.shared
    private let disposeBag = DisposeBag()
    
    private var videos: [PexelsVideo] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LiveVideoCollectionViewCell.self, forCellWithReuseIdentifier: LiveVideoCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.fetchAllAPI()
        viewModel.videos
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] videos in
                self?.videos = videos
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { errorMessage in
                print("❌ Error: \(errorMessage)")
            })
            .disposed(by: disposeBag)
    }
}

extension LiveViewCtr: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveVideoCollectionViewCell.identifier, for: indexPath) as? LiveVideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let video = videos[indexPath.item]
        if let file = video.video_files.first(where: { $0.quality == "hd" }) ?? video.video_files.first {
            cell.configure(with: file.link)
        }
        cell.nameButton.setTitle(video.user.name, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
