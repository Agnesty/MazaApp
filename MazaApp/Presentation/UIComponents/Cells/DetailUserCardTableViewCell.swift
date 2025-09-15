//
//  DetailUserCardTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 13/02/25.
//

import UIKit

class DetailUserCardTableViewCell: BaseTableViewCell {
    
    var detailUserCards: [DetailUserCardItem] = [] {
        didSet {
            cardCollectionView.reloadData()
        }
    }
    
    private lazy var cardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
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
        contentView.addSubview(cardCollectionView)
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        cardCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        
        // Aktifkan constraint dengan benar
        NSLayoutConstraint.activate([
            cardCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardCollectionView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        cardCollectionView.reloadData()
    }
    
}

extension DetailUserCardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailUserCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        let data = detailUserCards[indexPath.row]
        switch indexPath.item {
        case 0, 1, 2, 3:
            cell.configure(image: UIImage(systemName: data.iconName), text: data.text, bgColor: UIColor(hex: data.bgColorHex))
        default:
            break
        }
        return cell
    }
}
