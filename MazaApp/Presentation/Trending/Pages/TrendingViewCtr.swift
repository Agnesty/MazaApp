//
//  TrendingViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import SnapKit
import Combine

class TrendingViewCtr: BaseViewController {
    
    enum SectionTrending: Int, CaseIterable {
        case trendingProduct = 0
    }
    
    private let viewModel = TrendingViewModel.shared
    private let refreshControl = UIRefreshControl()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    private let headerView = TrendingHeaderView()
    private let tabHomeStickyHeader = TabMenuHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: ProductListTableViewCell.identifier)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        setupRefreshControl()
        
        headerView.didTapFavorite = { [weak self] in
            let favoriteVC = FavoriteProductViewCtr()
            self?.navigationController?.pushViewController(favoriteVC, animated: true)
        }
        headerView.didTapCart = { [weak self] in
            let cartVC = CartViewCtr()
            self?.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    private func bindViewModel() {
        viewModel.allCallTrendingAPI()
        
        // productResponse
        viewModel.productResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trendingData in
                guard let self = self else { return }
                let tabs = trendingData.map { TabsHomeMenu(id: $0.id, tabName: $0.productSource) }
                
                self.tableView.reloadData()
                self.tabHomeStickyHeader.configureTabs(tabs)
                self.tabHomeStickyHeader.didSelectTab = { [weak self] index in
                    self?.updateProducts(forTabIndex: index)
                }
                self.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        // products
        viewModel.products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        // errorMessage
        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] msg in
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor(hex: "#B08968")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
    }
    
    @objc private func refreshTriggered() {
        viewModel.allCallTrendingAPI()
    }
    
    private func updateProducts(forTabIndex index: Int) {
        let responses = viewModel.productResponse.value
        guard responses.indices.contains(index) else { return }
        
        let response = responses[index]
        let products = viewModel.products(for: response.id)
        print("✅ Trending Products for \(response.productSource): \(products.count)")
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: SectionTrending.trendingProduct.rawValue)) as? ProductListTableViewCell {
            cell.configure(with: products)
        }
        
        tabHomeStickyHeader.setSelectedTab(index)
    }
}

extension TrendingViewCtr: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTrending.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SectionTrending(rawValue: section)
        switch sectionType {
        case .trendingProduct:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionTrending(rawValue: indexPath.section)
        switch sectionType {
        case .trendingProduct:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as? ProductListTableViewCell else { return UITableViewCell() }
            
            if let firstResponse = viewModel.productResponse.value.first {
                let products = viewModel.products(for: firstResponse.id)
                cell.configure(with: products)
            }
            
            cell.didSelectProduct = { [weak self] product in
                print("Selected product: \(String(describing: product.productName))")
                let detailVC = ProductDetailViewCtr()
                detailVC.product = product
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .cyan
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == SectionTrending.trendingProduct.rawValue ? 40 : .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SectionTrending.trendingProduct.rawValue {
            return tabHomeStickyHeader
        }
        return nil
    }
}
