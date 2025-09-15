//
//  DescriptionTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 29/07/25.
//

import Foundation
import UIKit
import SnapKit

class DescriptionTableViewCell: BaseTableViewCell {
    
    private let descLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        descLabel.font = .systemFont(ofSize: 14)
        descLabel.numberOfLines = 0

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with product: Product) {
        descLabel.text = product.description.isEmpty ? "Tidak ada deskripsi" : product.description
    }
}
