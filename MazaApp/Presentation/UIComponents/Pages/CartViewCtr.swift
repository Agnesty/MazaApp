//
//  CartViewController.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 05/08/25.
//

import UIKit
import SnapKit

class CartViewCtr: BaseViewController {
    
    private let topBarView = TopBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(topBarView)
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        topBarView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        topBarView.setRightVisibility(showWishlist: true, showMenu: true)
        topBarView.setLeftVisibility(showBack: true, showTitle: true)
        topBarView.setTitle("Cart")
    }
}
