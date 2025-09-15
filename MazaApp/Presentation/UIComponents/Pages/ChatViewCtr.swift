//
//  MessageViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 05/08/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChatViewCtr: BaseViewController {
    
    private let viewModel = HomeViewModel.shared
    private let disposeBag = DisposeBag()
    
    enum SectionChat: Int, CaseIterable {
        case topCategoryMenu
        case chatList
        case recommendationForYou
    }
    
    private let topBarView = TopBarView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(topBarView)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(DetailUserCardTableViewCell.self, forCellReuseIdentifier: DetailUserCardTableViewCell.identifier)
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: ProductListTableViewCell.identifier)
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        topBarView.setRightVisibility()
        topBarView.setLeftVisibility(showBack: true, showTitle: true)
        topBarView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        topBarView.setTitle("Chat")
    }
    
    private func bindViewModel() {
        if viewModel.productResponse.value.isEmpty {
            viewModel.fetchProducts()
        }
        
        viewModel.productResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { msg in
                print("⚠️ Error: \(msg)")
            })
            .disposed(by: disposeBag)
    }
}

extension ChatViewCtr: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionChat.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionChat(rawValue: section) {
        case .topCategoryMenu: return 1
        case .chatList: return 1
        case .recommendationForYou: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionChat(rawValue: indexPath.section) {
        case .topCategoryMenu:
            return tableView.dequeueReusableCell(withIdentifier: DetailUserCardTableViewCell.identifier, for: indexPath) as! DetailUserCardTableViewCell
            
        case .chatList:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Chat list placeholder"
            cell.backgroundColor = .secondarySystemBackground
            return cell
            
        case .recommendationForYou:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as? ProductListTableViewCell else { return UITableViewCell() }
            
            let products = viewModel.products(for: 1)
            cell.configure(with: products)

            cell.didSelectProduct = { [weak self] product in
                print("Selected product: \(String(describing: product.productName))")
                let detailVC = ProductDetailViewCtr()
                detailVC.product = product
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
