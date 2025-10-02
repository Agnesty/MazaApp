//
//  ProductPagerTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 01/10/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ProductPagerTableViewCell: BaseTableViewCell {
    var isGridScrollEnabled: (() -> Bool)? = { true }
    var didScrollToPage: ((Int) -> Void)?
    var didSelectProduct: ((Product) -> Void)?
    private var categories: [TabsHomeMenu] = []
    private var productsDict: [Int: [Product]] = [:]
    
    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        observeContentSizeChanges()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        observeContentSizeChanges()
    }
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductGridPageCell.self, forCellWithReuseIdentifier: ProductGridPageCell.identifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0) // default dulu, nanti di-update otomatis
        }
    }
    
    internal func observeContentSizeChanges() {
        collectionView.rx.observe(\.contentSize)
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] size in
                guard let self = self else { return }
                self.collectionView.snp.updateConstraints { $0.height.equalTo(size.height)}
            })
            .disposed(by: disposeBag)
    }
    
    func configure(categories: [TabsHomeMenu], productsDict: [Int: [Product]]) {
        self.categories = categories
        self.productsDict = productsDict
        collectionView.reloadData()
    }
    
    func scrollToPage(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setGridScrollEnabled(_ enabled: Bool) {
        for case let cell as ProductGridPageCell in collectionView.visibleCells {
            cell.isCollectionViewCellScrollEnabled(enabled)
        }
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
        
        let enabled = isGridScrollEnabled?() ?? true
        cell.isCollectionViewCellScrollEnabled(enabled)
        cell.didSelectProduct = { [weak self] product in
            self?.didSelectProduct?(product)
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
