//
//  ProductListTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 26/07/25.
//

import UIKit
import SnapKit

class ProductListTableViewCell: BaseTableViewCell {
    
    var didSelectProduct: ((Product) -> Void)?
    
    private var products: [Product] = []
    private var collectionView: UICollectionView!
    
    private var heightCache: [Int: CGFloat] = [:]
    private var lastWidth: CGFloat = 0
    private lazy var sizingCell = ListProductCollectionViewCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if collectionView.bounds.width != lastWidth {
            lastWidth = collectionView.bounds.width
            heightCache.removeAll()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ListProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ListProductCollectionViewCell.identifier
        )
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with products: [Product]) {
        self.products = products
        heightCache.removeAll()
        collectionView.reloadData()
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        return CGSize(width: targetSize.width, height: contentHeight)
    }
    
    private func measureHeight(for product: Product, width: CGFloat) -> CGFloat {
        sizingCell.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        sizingCell.configure(with: product)
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        let target = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let size = sizingCell.contentView.systemLayoutSizeFitting(
            target,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return ceil(size.height)
    }
}

extension ProductListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListProductCollectionViewCell.identifier, for: indexPath) as? ListProductCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        didSelectProduct?(selectedProduct)
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
        if pairIndex >= 0 && pairIndex < products.count {
            heightCache[pairIndex] = maxHeight
        }

        return CGSize(width: itemWidth, height: maxHeight)
    }
}


