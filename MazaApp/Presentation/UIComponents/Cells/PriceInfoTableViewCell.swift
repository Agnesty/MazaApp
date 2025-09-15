//
//  PriceInfoTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 29/07/25.
//

import Foundation
import UIKit
import SnapKit

class PriceInfoTableViewCell: BaseTableViewCell {
    
    private let nameLabel = UILabel()
    
    private let priceLabel = UILabel()
    private let originalPriceLabel = UILabel()
    private let priceRowStack = UIStackView()
    
    private let discountContainer = UIView()
    private let discountLabel = UILabel()
    private let discountRowStack = UIStackView()
    
    private let ratingLabel = UILabel()
    private let promoLabel = UILabel()
    private let storeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        // Product name
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.numberOfLines = 2
        
        // Price after discount
        priceLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        priceLabel.textColor = .label
        
        // Original price
        originalPriceLabel.font = .systemFont(ofSize: 18)
        originalPriceLabel.textColor = .secondaryLabel
        
        // Price row (price + original price)
        priceRowStack.axis = .horizontal
        priceRowStack.spacing = 8
        priceRowStack.alignment = .firstBaseline
        priceRowStack.addArrangedSubview(priceLabel)
        priceRowStack.addArrangedSubview(originalPriceLabel)
        
        // Discount capsule
        discountLabel.font = .systemFont(ofSize: 14, weight: .bold)
        discountLabel.textColor = .white
        discountLabel.textAlignment = .center
        
        discountContainer.backgroundColor = .systemRed
        discountContainer.layer.cornerRadius = 12
        discountContainer.layer.masksToBounds = true
        discountContainer.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        }
        
        // Wrap discount supaya tidak full width
        discountRowStack.axis = .horizontal
        discountRowStack.alignment = .leading
        discountRowStack.addArrangedSubview(discountContainer)
        
        // Rating
        ratingLabel.font = .systemFont(ofSize: 14)
        ratingLabel.textColor = .secondaryLabel
        
        // Promo
        promoLabel.font = .systemFont(ofSize: 14)
        promoLabel.textColor = .systemRed
        
        // Store
        storeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        storeLabel.textColor = .label
        
        // Main stack
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            priceRowStack,
            discountRowStack,
            ratingLabel,
            promoLabel,
            storeLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8
        contentView.addSubview(stack)
        
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Formatter
    private static let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = "."
        f.locale = Locale(identifier: "id_ID")
        return f
    }()
    
    func configure(with product: Product) {
        nameLabel.text = product.productName
        
        let formatter = Self.priceFormatter
        let discounted = formatter.string(from: NSNumber(value: product.priceAfterDiscount))
            ?? "\(product.priceAfterDiscount)"
        priceLabel.text = "Rp \(discounted)"
        
        let original = formatter.string(from: NSNumber(value: product.originalPrice))
            ?? "\(product.originalPrice)"
        originalPriceLabel.attributedText = NSAttributedString(
            string: "Rp \(original)",
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        discountLabel.text = "Discount: \(product.discountPercentage)"
        ratingLabel.text = product.ratingText
        promoLabel.text = product.promoText
        storeLabel.text = product.storeName
    }
}
