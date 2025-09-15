//
//  TrendingHeaderView.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 26/07/25.
//

import UIKit
import SnapKit

class TrendingHeaderView: UIView {
    
    var didTapFavorite: (() -> Void)?
    var didTapCart: (() -> Void)?

    private let trendingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Fire")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let trendingLabel: UILabel = {
        let label = UILabel()
        label.text = "TRENDING"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 241/255, green: 62/255, blue: 35/255, alpha: 1)
        return label
    }()

    let favoriteButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()

    let cartButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "cart")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let cartBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textColor = .white
        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        setupGestures()
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(trendingIcon)
        addSubview(trendingLabel)
        addSubview(favoriteButton)
        addSubview(cartButton)
        addSubview(cartBadgeLabel)
    }

    private func setupConstraints() {
        trendingIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }

        trendingLabel.snp.makeConstraints { make in
            make.leading.equalTo(trendingIcon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }

        cartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(cartButton.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }

        cartBadgeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cartButton.snp.trailing)
            make.centerY.equalTo(cartButton.snp.top)
            make.width.greaterThanOrEqualTo(16)
            make.height.equalTo(16)
        }
    }

    private func setupGestures() {
        let favTap = UITapGestureRecognizer(target: self, action: #selector(handleFavoriteTap))
        favoriteButton.addGestureRecognizer(favTap)

        let cartTap = UITapGestureRecognizer(target: self, action: #selector(handleCartTap))
        cartButton.addGestureRecognizer(cartTap)
    }

    @objc private func handleFavoriteTap() {
        didTapFavorite?()
    }

    @objc private func handleCartTap() {
        didTapCart?()
    }

    func updateCartBadge(count: Int) {
        cartBadgeLabel.text = "\(count)"
        cartBadgeLabel.isHidden = count == 0
    }
}
