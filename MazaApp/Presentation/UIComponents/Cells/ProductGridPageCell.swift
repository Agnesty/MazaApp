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
    var didUpdateHeight: ((CGFloat) -> Void)?
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self = self else { return }
            self.collectionView.layoutIfNeeded()
            
            let newHeight = self.collectionView.contentSize.height
            if newHeight > 100 { self.didUpdateHeight?(newHeight)}
        }
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
        
           let row = indexPath.item / Int(columns)
           let leftIndex = row * Int(columns)
           let rightIndex = min(leftIndex + 1, products.count - 1)

           if let cachedHeight = heightCache[row] {
               return CGSize(width: itemWidth, height: cachedHeight)
           }

           let leftHeight = measureHeight(for: products[leftIndex], width: itemWidth)
           let rightHeight = measureHeight(for: products[rightIndex], width: itemWidth)

           let rowHeight = max(leftHeight, rightHeight)

           heightCache[leftIndex] = rowHeight
           heightCache[rightIndex] = rowHeight
           heightCache[row] = rowHeight

           return CGSize(width: itemWidth, height: rowHeight)
       }

    private func measureHeight(for product: Product, width: CGFloat) -> CGFloat {
        sizingCell.frame = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
        sizingCell.configure(with: product)
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()

        let target = CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)
        let size = sizingCell.contentView.systemLayoutSizeFitting(
            target,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return ceil(size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        didSelectProduct?(selectedProduct)
    }
}

