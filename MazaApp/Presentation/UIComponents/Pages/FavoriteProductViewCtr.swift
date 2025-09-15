//
//  FavoriteProductViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 09/09/25.
//

import UIKit

class FavoriteProductViewCtr: UIViewController {
    
    private var topBar = TopBarView()
    private var collectionView: UICollectionView!
    private var products: [Product] = []
    
    // Cache tinggi item
    private var heightCache: [Int: CGFloat] = [:]
    private var lastWidth: CGFloat = 0
    private lazy var sizingCell = ListProductCollectionViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTopBar()
        setupCollectionView()
        loadFavoriteProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteProducts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // invalidasi cache & layout kalau lebar berubah
        if collectionView.bounds.width != lastWidth {
            lastWidth = collectionView.bounds.width
            heightCache.removeAll()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
    }
    
    private func setupTopBar() {
        view.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        topBar.setTitle("Favorites")
        topBar.setLeftVisibility(showBack: true, showTitle: true)
        topBar.setRightVisibility()
        
        topBar.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ListProductCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func loadFavoriteProducts() {
        products = CoreDataManager.shared.fetchFavoriteProducts()
        collectionView.reloadData()
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        if products.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "Empty"
            emptyLabel.textColor = .systemGray
            emptyLabel.font = .systemFont(ofSize: 18, weight: .medium)
            emptyLabel.textAlignment = .center
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func measureHeight(for product: Product, width: CGFloat) -> CGFloat {
        sizingCell.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        sizingCell.configure(with: product)
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        let target = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        return sizingCell.contentView.systemLayoutSizeFitting(
            target,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }
    
    @objc private func handleDelete(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let cell = gesture.view as? ListProductCollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let product = products[indexPath.item]
        CoreDataManager.shared.deleteFavorite(id: product.id)
        products.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        updateEmptyState()
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension FavoriteProductViewCtr: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListProductCollectionViewCell.identifier, for: indexPath) as? ListProductCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: products[indexPath.item])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleDelete(_:)))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ProductDetailViewCtr()
        detailVC.product = products[indexPath.item]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let interitem: CGFloat = 4
        let availableWidth = collectionView.bounds.width
        - collectionView.contentInset.left
        - collectionView.contentInset.right
        - (columns - 1) * interitem
        let itemWidth = floor(availableWidth / columns)
        
        if let h = heightCache[indexPath.item] {
            return CGSize(width: itemWidth, height: h)
        }
        
        let thisHeight = measureHeight(for: products[indexPath.item], width: itemWidth)
        
        let isLeft = indexPath.item % 2 == 0
        let pairIndex = isLeft ? indexPath.item + 1 : indexPath.item - 1
        var pairHeight: CGFloat?
        
        if pairIndex >= 0 && pairIndex < products.count {
            pairHeight = heightCache[pairIndex] ?? measureHeight(for: products[pairIndex], width: itemWidth)
        }
        
        let maxHeight = max(thisHeight, pairHeight ?? thisHeight)
        heightCache[indexPath.item] = maxHeight
        if let pair = pairIndex as Int?, pair >= 0 && pair < products.count {
            heightCache[pair] = maxHeight
        }
        
        return CGSize(width: itemWidth, height: maxHeight)
    }
}
