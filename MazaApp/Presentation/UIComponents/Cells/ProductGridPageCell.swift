//
//  ProductGridPageCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 01/10/25.
//

import Foundation
import UIKit

class ProductGridPageCell: BaseCollectionViewCell {
    
    var didSelectProduct: ((Product) -> Void)?
    private var products: [Product] = []
    private var collectionView: UICollectionView!
    private var heightCache: [Int: CGFloat] = [:]
    private lazy var sizingCell = ListProductCollectionViewCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        isCollectionViewCellScrollEnabled()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListProductCollectionViewCell.self, forCellWithReuseIdentifier: ListProductCollectionViewCell.identifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func isCollectionViewCellScrollEnabled(_ enabled: Bool = true) {
        collectionView.isScrollEnabled = enabled
    }
    
    func configure(products: [Product]) {
        self.products = products
        heightCache.removeAll()
        collectionView.reloadData()
    }
}

extension ProductGridPageCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell( withReuseIdentifier: ListProductCollectionViewCell.identifier, for: indexPath) as? ListProductCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        
        sizingCell.frame = CGRect(x: 0, y: 0, width: itemWidth, height: 0)
        sizingCell.configure(with: products[indexPath.item])
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        let target = CGSize(width: itemWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = sizingCell.contentView.systemLayoutSizeFitting(target, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        let finalHeight = ceil(size.height)
        heightCache[indexPath.item] = finalHeight
        return CGSize(width: itemWidth, height: finalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let selectedProduct = products[indexPath.item]
           didSelectProduct?(selectedProduct)
       }
}




