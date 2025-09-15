//
//  TopBarView.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 29/07/25.
//

import UIKit
import SnapKit

class TopBarView: UIView {
    
    // MARK: - Callbacks
    var onBackButtonTapped: (() -> Void)?
    var onWishlistTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onCartTapped: (() -> Void)?
    var onMenuTapped: (() -> Void)?

    // MARK: - Subviews
    private let backImageView = UIImageView()
    private let titleLabel = UILabel()

    let wishlistImageView = UIImageView()
    private let searchImageView = UIImageView()
    private let shareImageView = UIImageView()
    private let cartImageView = UIImageView()
    private let menuImageView = UIImageView()
    
    private let cartBadgeLabel = UILabel()
    private let redDot = UIView()

    private let leftStack = UIStackView()
    private let rightStack = UIStackView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white

        // MARK: Back button
        backImageView.image = UIImage(systemName: "chevron.backward")
        backImageView.contentMode = .scaleAspectFit
        backImageView.tintColor = .label
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backTapped)))
        backImageView.snp.makeConstraints { $0.size.equalTo(26) }

        // Title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.text = "Title"

        leftStack.axis = .horizontal
        leftStack.alignment = .center
        leftStack.spacing = 8
        leftStack.addArrangedSubview(backImageView)
        leftStack.addArrangedSubview(titleLabel)
        addSubview(leftStack)

        // MARK: Right icons
        setupIcon(imageView: wishlistImageView, systemName: "heart", action: #selector(wishlistTapped))
        setupIcon(imageView: searchImageView, systemName: "magnifyingglass", action: #selector(searchTapped))
        setupIcon(imageView: shareImageView, systemName: "arrowshape.turn.up.right", action: #selector(shareTapped))
        setupIcon(imageView: cartImageView, systemName: "cart", action: #selector(cartTapped))
        setupIcon(imageView: menuImageView, systemName: "line.3.horizontal", action: #selector(menuTapped))

        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 16
        [wishlistImageView, searchImageView, shareImageView, cartImageView, menuImageView].forEach { rightStack.addArrangedSubview($0) }

        addSubview(rightStack)

        // Badge
        cartBadgeLabel.text = "5"
        cartBadgeLabel.font = .systemFont(ofSize: 10, weight: .bold)
        cartBadgeLabel.textColor = .white
        cartBadgeLabel.backgroundColor = .systemRed
        cartBadgeLabel.textAlignment = .center
        cartBadgeLabel.layer.cornerRadius = 8
        cartBadgeLabel.layer.masksToBounds = true
        cartBadgeLabel.isHidden = true
        addSubview(cartBadgeLabel)

        // Red Dot
        redDot.backgroundColor = .systemRed
        redDot.layer.cornerRadius = 4
        redDot.layer.masksToBounds = true
        redDot.isHidden = true
        addSubview(redDot)

        setupConstraints()
        setRightVisibility()
        setLeftVisibility()
    }

    private func setupIcon(imageView: UIImageView, systemName: String, action: Selector) {
        imageView.image = UIImage(systemName: systemName)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        imageView.snp.makeConstraints { $0.size.equalTo(26) }
    }

    private func setupConstraints() {
        leftStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        rightStack.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        cartBadgeLabel.snp.makeConstraints {
            $0.top.equalTo(cartImageView.snp.top).offset(-4)
            $0.trailing.equalTo(cartImageView.snp.trailing).offset(4)
            $0.width.height.greaterThanOrEqualTo(16)
        }

        redDot.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.top.equalTo(menuImageView.snp.top).offset(-2)
            $0.trailing.equalTo(menuImageView.snp.trailing).offset(2)
        }
    }

    // MARK: - Actions
    @objc private func backTapped() {
        onBackButtonTapped?()
    }
    
    @objc private func wishlistTapped() {
        onWishlistTapped?()
    }

    @objc private func searchTapped() {
        onSearchTapped?()
    }

    @objc private func shareTapped() {
        onShareTapped?()
    }

    @objc private func cartTapped() {
        onCartTapped?()
    }

    @objc private func menuTapped() {
        onMenuTapped?()
    }

    // MARK: - Public APIs
    func setTitle(_ text: String) {
        titleLabel.text = text
    }

    func setLeftVisibility(showBack: Bool = false, showTitle: Bool = false) {
        backImageView.isHidden = !showBack
        titleLabel.isHidden = !showTitle
    }

    func setRightVisibility(showSearch: Bool = false, showWishlist: Bool = false, showShare: Bool = false, showCart: Bool = false, showMenu: Bool = false) {
        searchImageView.isHidden = !showSearch
        wishlistImageView.isHidden = !showWishlist
        shareImageView.isHidden = !showShare
        cartImageView.isHidden = !showCart
        menuImageView.isHidden = !showMenu
    }

    func setCartBadge(count: Int) {
        cartBadgeLabel.text = "\(count)"
        cartBadgeLabel.isHidden = count <= 0
    }

    func showRedDot(_ show: Bool) {
        redDot.isHidden = !show
    }
    
    func setWishlistIcon(filled: Bool) {
        wishlistImageView.image = UIImage(systemName: filled ? "heart.fill" : "heart")
    }
}
