//
//  ProductDetailSkeletonTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 11/09/25.
//

import UIKit
import SkeletonView

class ProductDetailSkeletonTableViewCell: BaseTableViewCell {
    
    let imageHeaderSkeleton = UIView()
    let priceInfoSkeleton = UIView()
    let descriptionSkeleton = UIView()
    
    private var skeletonViews: [UIView] {
        return [imageHeaderSkeleton, priceInfoSkeleton, descriptionSkeleton]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSkeletonViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeletonViews()
    }
    
    private func setupSkeletonViews() {
        contentView.isSkeletonable = true
        
        skeletonViews.forEach { view in
            view.isSkeletonable = true
            view.backgroundColor = .systemGray5
            view.layer.cornerRadius = 12
            view.clipsToBounds = true
            contentView.addSubview(view)
        }
        
        imageHeaderSkeleton.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        priceInfoSkeleton.snp.makeConstraints { make in
            make.top.equalTo(imageHeaderSkeleton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        descriptionSkeleton.snp.makeConstraints { make in
            make.top.equalTo(priceInfoSkeleton.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
    }
    
    func showSkeleton(for section: SectionProductDetail) {
        skeletonViews.forEach { $0.isHidden = true }
        
        let targetView: UIView
        switch section {
        case .imageHeaderCell: targetView = imageHeaderSkeleton
        case .priceInfoCell: targetView = priceInfoSkeleton
        case .descriptionCell: targetView = descriptionSkeleton
        }
        
        targetView.isHidden = false
        let gradient = SkeletonGradient(baseColor: .systemGray5, secondaryColor: .systemGray4)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        targetView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
    
    func hideSkeleton() {
        skeletonViews.forEach { $0.hideSkeleton() }
    }
}
