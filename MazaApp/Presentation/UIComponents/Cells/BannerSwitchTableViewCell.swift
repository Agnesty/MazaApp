//
//  BannerSwitchTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 10/02/25.
//

import UIKit
import Kingfisher

class BannerSwitchTableViewCell: BaseTableViewCell {

    private var timer: Timer?
    private var currentIndex = 0
    var banners: [Banners] = [] {
        didSet {
            currentIndex = 0
            bannerCollectionView.reloadData()
            setupIndicators()
        }
    }
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // stack untuk pagination indicator
    private lazy var pageIndicatorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var indicatorViews: [UIView] = []
    
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
        setupIndicators()
        startAutoScroll()
    }
    
    private func setupUI() {
        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(pageIndicatorStack)
        
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.register(BannerSwitchCollectionViewCell.self, forCellWithReuseIdentifier: BannerSwitchCollectionViewCell.identifier)

        NSLayoutConstraint.activate([
            bannerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 120),
            bannerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            pageIndicatorStack.bottomAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: -8),
            pageIndicatorStack.centerXAnchor.constraint(equalTo: bannerCollectionView.centerXAnchor)
        ])
    }
    
    private func setupIndicators() {
        indicatorViews.forEach { $0.removeFromSuperview() }
        indicatorViews.removeAll()
        
        guard banners.count > 0 else { return }
        
        for _ in 0..<banners.count {
            let dot = UIView()
            dot.backgroundColor = .lightGray
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
            pageIndicatorStack.addArrangedSubview(dot)
            indicatorViews.append(dot)
        }
        
        updateIndicators(animated: false)
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(moveToNextBanner), userInfo: nil, repeats: true)
    }
    
    @objc private func moveToNextBanner() {
        guard banners.count > 0 else { return }
        
        currentIndex = (currentIndex + 1) % banners.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateIndicators(animated: true)
    }
    
    private func updateIndicators(animated: Bool) {
        for (i, dot) in indicatorViews.enumerated() {
            dot.subviews.forEach { $0.removeFromSuperview() }
            
            if i == currentIndex {
                // Aktif → lonjong container
                dot.backgroundColor = .lightGray
                dot.layer.cornerRadius = 4
                dot.constraints.first { $0.firstAttribute == .width }?.constant = 20
                dot.constraints.first { $0.firstAttribute == .height }?.constant = 8
                dot.layoutIfNeeded()
                
                // Tambah fillView kuning
                let fillView = UIView()
                fillView.backgroundColor = .cyan
//                UIColor(hex: "#EDE0D4")
                fillView.layer.cornerRadius = 4
                fillView.translatesAutoresizingMaskIntoConstraints = false
                dot.addSubview(fillView)
                
                NSLayoutConstraint.activate([
                    fillView.leadingAnchor.constraint(equalTo: dot.leadingAnchor),
                    fillView.topAnchor.constraint(equalTo: dot.topAnchor),
                    fillView.bottomAnchor.constraint(equalTo: dot.bottomAnchor),
                    fillView.widthAnchor.constraint(equalToConstant: 0) // mulai dari 0
                ])
                
                dot.layoutIfNeeded()
                
                // Animasi lebar fillView 0 → 20
                if let widthConstraint = fillView.constraints.first(where: { $0.firstAttribute == .width }) {
                    widthConstraint.constant = 20
                    UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear) {
                        dot.layoutIfNeeded()
                    }
                }
            } else {
                // Non aktif → bulat
                dot.backgroundColor = .lightGray
                dot.layer.cornerRadius = 4
                dot.constraints.first { $0.firstAttribute == .width }?.constant = 8
                dot.constraints.first { $0.firstAttribute == .height }?.constant = 8
                dot.layoutIfNeeded()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension BannerSwitchTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerSwitchCollectionViewCell.identifier, for: indexPath) as? BannerSwitchCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: banners[indexPath.row].imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
}
