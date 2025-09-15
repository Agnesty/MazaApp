//
//  SellingServiceTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 13/02/25.
//

import UIKit

class SellingServiceTableViewCell: BaseTableViewCell {
    
    var sellingServices: [SellingServiceItem] = [] {
        didSet {
            cardOvalCollectionView.reloadData()
        }
    }
    
    private lazy var cardOvalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configView()
    }
    
    override func configView() {
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(cardOvalCollectionView)
        
        cardOvalCollectionView.dataSource = self
        cardOvalCollectionView.delegate = self
        cardOvalCollectionView.register(CardOvalCollectionViewCell.self, forCellWithReuseIdentifier: CardOvalCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            cardOvalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardOvalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardOvalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardOvalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardOvalCollectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        cardOvalCollectionView.reloadData()
    }
    
}

extension SellingServiceTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardOvalCollectionViewCell.identifier, for: indexPath) as? CardOvalCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item < sellingServices.count {
            let item = sellingServices[indexPath.item]
            cell.configure(image: item.imageUrl, title: item.title)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 110)
    }
    
}
