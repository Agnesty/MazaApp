//
//  ProductListViewController.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 07/09/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProductListViewCtr: BaseViewController {

    var didSelectProduct: ((Product) -> Void)?

    private var categoryId: Int = 0
    private var products: [Product] = []
    private let viewModel = HomeViewModel.shared
    private let disposeBag = DisposeBag()

    private var collectionView: UICollectionView!

    private var heightCache: [Int: CGFloat] = [:]
    private var lastWidth: CGFloat = 0

    private lazy var sizingCell = ListProductCollectionViewCell()

    init(category: Int) {
        self.categoryId = category
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindProducts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionView.bounds.width != lastWidth {
            lastWidth = collectionView.bounds.width
            heightCache.removeAll()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ListProductCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func bindProducts() {
        viewModel.products
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dict in
                guard let self = self else { return }
                self.products = dict[self.categoryId] ?? []
                self.heightCache.removeAll()
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
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
        return size.height
    }
}

extension ProductListViewCtr: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListProductCollectionViewCell.identifier, for: indexPath
        ) as! ListProductCollectionViewCell
        cell.configure(with: products[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectProduct?(products[indexPath.item])
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

        // kalau sudah ada di cache, langsung pakai
        if let h = heightCache[indexPath.item] {
            return CGSize(width: itemWidth, height: h)
        }

        // hitung tinggi item ini & pasangannya dalam baris yang sama
        let thisHeight = measureHeight(for: products[indexPath.item], width: itemWidth)

        let isLeft = indexPath.item % 2 == 0
        let pairIndex = isLeft ? indexPath.item + 1 : indexPath.item - 1
        var pairHeight: CGFloat?

        if pairIndex >= 0 && pairIndex < products.count {
            pairHeight = heightCache[pairIndex] ?? measureHeight(for: products[pairIndex], width: itemWidth)
        }

        let maxHeight = max(thisHeight, pairHeight ?? thisHeight)

        // simpan keduanya supaya baris punya tinggi sama
        heightCache[indexPath.item] = maxHeight
        if let pair = pairIndex as Int?, pair >= 0 && pair < products.count {
            heightCache[pair] = maxHeight
        }

        return CGSize(width: itemWidth, height: maxHeight)
    }
}
