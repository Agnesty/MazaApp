//
//  ImageHeaderTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 29/07/25.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class ImageHeaderTableViewCell: BaseTableViewCell {
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: Product) {
        if let url = URL(string: product.imageURL) {
            productImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            productImageView.image = UIImage(systemName: "xmark.circle")
        }
    }
}
