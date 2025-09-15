//
//  NotificationViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import RxSwift
import RxCocoa

final class PokemonViewCtr: BaseViewController {
    private let viewModel = PokemonViewModel.shared
    private let disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar()
    private let filterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .systemGray6
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 120)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var searchContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchBar, filterButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokédex"
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(searchContainer)
        view.addSubview(collectionView)
        
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            searchContainer.heightAnchor.constraint(equalToConstant: 44),
            
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            
            collectionView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.callAllAPI()
        
        viewModel.filteredPokemons
            .bind(to: collectionView.rx.items(cellIdentifier: PokemonCollectionViewCell.identifier, cellType: PokemonCollectionViewCell.self)) { _, pokemon, cell in
                cell.configure(with: pokemon)
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { [weak self] errorMsg in
                let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
        
        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterOptions()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Pokemon.self)
            .flatMapLatest { [weak self] pokemon -> Observable<(Pokemon, PokemonStats)> in
                guard let self = self else { return .empty() }
                return self.viewModel.fetchDetail(for: pokemon.id)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (pokemon, stats) in
                let vc = PokemonDetailViewCtr(pokemon: pokemon, stats: stats)
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }, onError: { [weak self] err in
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func showFilterOptions() {
        let filterVC = FilterPokemonViewCtr()
        
        if #available(iOS 15.0, *) {
            if let sheet = filterVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20  
            }
            present(filterVC, animated: true)
        } else {
            // Fallback untuk iOS 14 kebawah → present biasa full screen
            let nav = UINavigationController(rootViewController: filterVC)
            nav.modalPresentationStyle = .overFullScreen
            present(nav, animated: true)
        }
    }
    
}

