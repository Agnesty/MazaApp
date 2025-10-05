//
//  ProductPagerTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 01/10/25.
//

import Foundation
import UIKit

class ProductPagerTableViewCell: BaseTableViewCell {
    var enableToScroll: Bool = true
    var didScrollToPage: ((Int) -> Void)?
    var didSelectProduct: ((Product) -> Void)?
    private var categories: [TabsHomeMenu] = []
    private var productsDict: [Int: [Product]] = [:]
    private var collectionView: UICollectionView!
    private var isUpdatingHeight = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(ProductGridPageCell.self, forCellWithReuseIdentifier: ProductGridPageCell.identifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(800)
        }
    }
    
    func configure(categories: [TabsHomeMenu], productsDict: [Int: [Product]]) {
        self.categories = categories
        self.productsDict = productsDict
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    func scrollToPage(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ProductPagerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductGridPageCell.identifier,
            for: indexPath
        ) as? ProductGridPageCell else { return UICollectionViewCell() }
        
        let cat = categories[indexPath.item]
        let prods = productsDict[cat.id] ?? []
        cell.didSelectProduct = { [weak self] product in
            self?.didSelectProduct?(product)
        }
        cell.isCollectionViewCellScrollEnabled(enableToScroll)
        cell.didUpdateHeight = { [weak self] height in
            guard let self = self else { return }
            self.collectionView.snp.updateConstraints { $0.height.equalTo(height) }
            self.collectionView.layoutIfNeeded()
            self.setNeedsLayout()
            self.layoutIfNeeded()

            if let tableView = self.superview as? UITableView {
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
        }
        cell.configure(products: prods)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        didScrollToPage?(page)
    }
}
