//
//  PokemonCollectionViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 12/09/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PokemonCollectionViewCell: BaseCollectionViewCell {
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        typeLabel.text = pokemon.types.joined(separator: ", ")
        if let urlStr = pokemon.imageUrl, let url = URL(string: urlStr) {
            imageView.kf.setImage(with: url)
        }
        
        if let type = pokemon.types.first?.lowercased() {
            switch type {
            case "grass": contentView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.7)
            case "fire": contentView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.7)
            case "water": contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
            case "electric": contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.7)
            default: contentView.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        typeLabel.font = .systemFont(ofSize: 12)
        typeLabel.textColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(imageView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(80)
        }
    }
}
