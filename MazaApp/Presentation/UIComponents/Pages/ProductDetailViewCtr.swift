//
//  ProductDetailViewController.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 29/07/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum SectionProductDetail: Int, CaseIterable {
    case imageHeaderCell = 0
    case priceInfoCell
    case descriptionCell
}

class ProductDetailViewCtr: BaseViewController {
    
    var product: Product?
    private let viewModel = HomeViewModel.shared
    private let disposeBag = DisposeBag()
    
    private let topBarView = TopBarView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let bottomBar = UIView()
    private let buyButton = UIButton()
    private let cartButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupBottomBar()
        updateWishlistIcon()
        
         viewModel.showProductDetailSkeleton.accept(true)
         tableView.reloadData()

         DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
             guard let self = self, let product = self.product else { return }
             self.viewModel.fetchProductDetail(id: product.id)
         }
        
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(topBarView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(ImageHeaderTableViewCell.self, forCellReuseIdentifier: ImageHeaderTableViewCell.identifier)
        tableView.register(PriceInfoTableViewCell.self, forCellReuseIdentifier: PriceInfoTableViewCell.identifier)
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        tableView.register(ProductDetailSkeletonTableViewCell.self, forCellReuseIdentifier: ProductDetailSkeletonTableViewCell.identifier)
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        topBarView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        topBarView.onSearchTapped = { [weak self] in
            let searchVC = HomeSearchViewCtr()
            searchVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        topBarView.setRightVisibility(showWishlist: true, showShare: true, showCart: true)
        topBarView.setLeftVisibility(showBack: true)
        topBarView.onWishlistTapped = { [weak self] in
            guard let self = self, let product = self.product else { return }
            
            if CoreDataManager.shared.isInFavorites(id: product.id) {
                CoreDataManager.shared.deleteFavorite(id: product.id)
                self.topBarView.setWishlistIcon(filled: false)
            } else {
                CoreDataManager.shared.saveFavorite(product: product)
                self.topBarView.setWishlistIcon(filled: true)
                
                UIView.animate(withDuration: 0.3) {
                    self.topBarView.wishlistImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                } completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.topBarView.wishlistImageView.transform = .identity
                    }
                }
            }
        }
    }
    
    private func bindViewModel() {
        if let product = product {
            viewModel.fetchProductDetail(id: product.id)
        }
        
        viewModel.showProductDetailSkeleton
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBottomBar() {
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = .systemBackground
        bottomBar.layer.shadowColor = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.1
        bottomBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomBar.layer.shadowRadius = 4
        
        bottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        buyButton.setTitle("Beli Sekarang", for: .normal)
        buyButton.backgroundColor = .systemGreen
        buyButton.layer.cornerRadius = 12
        buyButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        cartButton.setTitle("+ Keranjang", for: .normal)
        cartButton.backgroundColor = .systemTeal
        cartButton.layer.cornerRadius = 12
        cartButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        let hStack = UIStackView(arrangedSubviews: [buyButton, cartButton])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.distribution = .fillEqually
        bottomBar.addSubview(hStack)
        
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    private func updateWishlistIcon() {
        guard let product = product else { return }
        let isFavorite = CoreDataManager.shared.isInFavorites(id: product.id)
        topBarView.setWishlistIcon(filled: isFavorite)
    }
}

extension ProductDetailViewCtr: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionProductDetail.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionProductDetail(rawValue: indexPath.section) else { return UITableViewCell() }

        if viewModel.showProductDetailSkeleton.value {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailSkeletonTableViewCell.identifier, for: indexPath) as! ProductDetailSkeletonTableViewCell
            cell.showSkeleton(for: section)
            return cell
        }

        guard let product = product else { return UITableViewCell() }

        switch section {
        case .imageHeaderCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageHeaderTableViewCell.identifier, for: indexPath) as? ImageHeaderTableViewCell else {return UITableViewCell() }
            cell.configure(with: product)
            return cell
        case .priceInfoCell:
           guard let cell = tableView.dequeueReusableCell(withIdentifier: PriceInfoTableViewCell.identifier, for: indexPath) as? PriceInfoTableViewCell else {return UITableViewCell() }
            cell.configure(with: product)
            return cell
        case .descriptionCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as? DescriptionTableViewCell else {return UITableViewCell() }
            cell.configure(with: product)
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionProductDetail(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        
        switch section {
        case .imageHeaderCell:
            return 300
        case .priceInfoCell:
            return UITableView.automaticDimension
        case .descriptionCell:
            return UITableView.automaticDimension
        }
    }
}
