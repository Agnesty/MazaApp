//
//  RecommendationProductCollectionViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 26/07/25.
//

import UIKit
import SnapKit
import Kingfisher

class ListProductCollectionViewCell: BaseCollectionViewCell {
    
    private let shadowContainerView = UIView()
    private let productImageView = UIImageView()
    private let discountLabel = UILabel()
    
    private let productNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let originalPriceLabel = UILabel()
    private let promoLabel = UILabel()
    private let ratingLabel = UILabel()
    private let storeLabel = UILabel()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            productNameLabel,
            priceLabel,
            originalPriceLabel,
            promoLabel,
            ratingLabel,
            storeLabel
        ])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(productImageView)
        shadowContainerView.addSubview(discountLabel)
        shadowContainerView.addSubview(infoStack)
        
        shadowContainerView.layer.cornerRadius = 8
        shadowContainerView.backgroundColor = .white
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.1
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainerView.layer.shadowRadius = 4
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        
        discountLabel.font = .systemFont(ofSize: 11, weight: .bold)
        discountLabel.textColor = .white
        discountLabel.backgroundColor = .systemRed
        discountLabel.textAlignment = .center
        discountLabel.layer.cornerRadius = 4
        discountLabel.clipsToBounds = true
        
        productNameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        productNameLabel.numberOfLines = 2
        productNameLabel.lineBreakMode = .byTruncatingTail
        productNameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        productNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.textColor = .systemRed
        
        originalPriceLabel.font = .systemFont(ofSize: 12)
        originalPriceLabel.textColor = .secondaryLabel
        
        promoLabel.font = .systemFont(ofSize: 11)
        promoLabel.textColor = .darkGray
        promoLabel.numberOfLines = 1
        promoLabel.lineBreakMode = .byTruncatingTail
        promoLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        promoLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        ratingLabel.font = .systemFont(ofSize: 11)
        ratingLabel.textColor = .darkGray
        
        storeLabel.font = .systemFont(ofSize: 11)
        storeLabel.textColor = .gray
        storeLabel.numberOfLines = 0
        storeLabel.lineBreakMode = .byWordWrapping
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        shadowContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(productNameLabel.font.lineHeight * 2.0)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        discountLabel.snp.makeConstraints {
            $0.top.left.equalTo(productImageView).offset(6)
            $0.height.equalTo(18)
            $0.width.greaterThanOrEqualTo(30)
        }
        
        infoStack.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(6)
            $0.left.right.bottom.equalToSuperview().inset(6)
        }
    }
    
    func configure(with product: Product) {
        if let url = URL(string: product.imageURL) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "Photo"))
        } else {
            productImageView.image = UIImage(named: "Photo")
        }
        
        discountLabel.text = product.discountPercentage
        productNameLabel.text = product.productName
        priceLabel.text = "Rp \(product.priceAfterDiscount)"
        originalPriceLabel.attributedText = NSAttributedString(
            string: "Rp \(product.originalPrice)",
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.gray
            ]
        )
        promoLabel.text = product.promoText
        ratingLabel.text = "⭐️ \(product.ratingText)"
        storeLabel.text = product.storeName
    }
}
