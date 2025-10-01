//
//  HomeViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 08/02/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewCtr: BaseViewController, UITextFieldDelegate {
    
    enum SectionHome: Int, CaseIterable {
        case bannerSwitch = 0
        case detailUserCard
        case sellingService
        case recommendationProduct
    }
    
    private var isHeaderSticky: Bool = false
    private let viewModel = HomeViewModel.shared
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let tabHomeStickyHeader = TabMenuHeaderView()
    
    // Membuat IconApp
    private let IconAppView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Maza")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .cyan.withAlphaComponent(0.1)
        return imageView
    }()
    
    // Membuat Search Bar
    private let searchIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private let cameraIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "camera"))
        icon.tintColor = .gray
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Search"
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Mail
    private let chatIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "message")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Box Keranjang
    private let cartIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //TableView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupRefreshControl()
        bindViewModel()
    }
    
    private func setupUI() {
        // Add SubViews
        view.addSubview(IconAppView)
        view.addSubview(searchBarView)
        searchBarView.addSubview(searchIcon)
        searchBarView.addSubview(cameraIcon)
        searchBarView.addSubview(searchTextField)
        view.addSubview(chatIcon)
        view.addSubview(cartIcon)
        view.addSubview(tableView)
        
        // TableView Delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // TableView Register
        tableView.register(BannerSwitchTableViewCell.self, forCellReuseIdentifier: BannerSwitchTableViewCell.identifier)
        tableView.register(DetailUserCardTableViewCell.self, forCellReuseIdentifier: DetailUserCardTableViewCell.identifier)
        tableView.register(SellingServiceTableViewCell.self, forCellReuseIdentifier: SellingServiceTableViewCell.identifier)
        tableView.register(ProductPagerTableViewCell.self, forCellReuseIdentifier: ProductPagerTableViewCell.identifier)
        
        // Delegate untuk TextField
        searchTextField.delegate = self
        
        // Constraints
        NSLayoutConstraint.activate([
            // IconAppView
            IconAppView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            IconAppView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            IconAppView.widthAnchor.constraint(equalToConstant: 36),
            IconAppView.heightAnchor.constraint(equalToConstant: 36),
            
            // SearchBarView
            searchBarView.centerYAnchor.constraint(equalTo: IconAppView.centerYAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: IconAppView.trailingAnchor, constant: 8),
            searchBarView.trailingAnchor.constraint(equalTo: cartIcon.leadingAnchor, constant: -8),
            searchBarView.heightAnchor.constraint(equalToConstant: 36),
            
            // SearchIcon, CamereIcon, dan SearchTextField
            searchIcon.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 8),
            searchIcon.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            cameraIcon.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -8),
            cameraIcon.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            cameraIcon.widthAnchor.constraint(equalToConstant: 22),
            cameraIcon.heightAnchor.constraint(equalToConstant: 18),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: cameraIcon.leadingAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalTo: searchBarView.heightAnchor),
            
            // KeranjangIcon
            cartIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            cartIcon.leadingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: 8),
            cartIcon.widthAnchor.constraint(equalToConstant: 26),
            cartIcon.heightAnchor.constraint(equalToConstant: 26),
            
            // MailIcon
            chatIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            chatIcon.leadingAnchor.constraint(equalTo: cartIcon.trailingAnchor, constant: 8),
            chatIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chatIcon.widthAnchor.constraint(equalToConstant: 26),
            chatIcon.heightAnchor.constraint(equalToConstant: 26),
            
            //Container in every section of tableView
            tableView.topAnchor.constraint(equalTo: IconAppView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Tap Gesture for IconAppView
        let iconAppGesture = UITapGestureRecognizer(target: self, action: #selector(iconAppTapped))
        IconAppView.addGestureRecognizer(iconAppGesture)
        
        // Tap Gesture for SearchIcon
        let searchIconGesture = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped))
        searchIcon.addGestureRecognizer(searchIconGesture)
        
        // Tap Gesture for CartIcon
        let cartIconGesture = UITapGestureRecognizer(target: self, action: #selector(cartIconTapped))
        cartIcon.addGestureRecognizer(cartIconGesture)
        
        // Tap Gesture for MessageIcon
        let chatIconGesture = UITapGestureRecognizer(target: self, action: #selector(chatIconTapped))
        chatIcon.addGestureRecognizer(chatIconGesture)
    }
    
    private func bindViewModel() {
        viewModel.allCallHomeAPI()
        
        viewModel.homeData
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] homeData in
                self?.tableView.reloadData()
                self?.tabHomeStickyHeader.configureTabs(homeData.tabsHomeMenu)
                self?.tabHomeStickyHeader.didSelectTab = { [weak self] index in
                    if let pagerCell = self?.tableView.cellForRow(
                           at: IndexPath(row: 0, section: SectionHome.recommendationProduct.rawValue)
                       ) as? ProductPagerTableViewCell {
                           pagerCell.scrollToPage(index: index)
                       }
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] msg in
                print("⚠️ Error: \(msg)")
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor(hex: "#B08968")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl = refreshControl
        
        // Event ketika user tarik ke bawah
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.allCallHomeAPI()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func iconAppTapped() {
        let alert = UIAlertController(title: "Info", message: "Gambar diklik!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func searchIconTapped() {
        let searchVC = HomeSearchViewCtr()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func cartIconTapped() {
        let cartVC = CartViewCtr()
        cartVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc private func chatIconTapped() {
        let chatVC = ChatViewCtr()
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchVC = HomeSearchViewCtr()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
}

extension HomeViewCtr: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionHome.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = SectionHome(rawValue: section)
        switch sectionType {
        case .bannerSwitch:
            return 1
        case .detailUserCard:
            return 1
        case .sellingService:
            return 1
        case .recommendationProduct:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = SectionHome(rawValue: indexPath.section)
        switch sectionType {
        case .bannerSwitch, .detailUserCard, .sellingService:
            return UITableView.automaticDimension
        case .recommendationProduct:
            if isHeaderSticky {
                return UITableView.automaticDimension
            } else {
                let tabHeight: CGFloat = max(tabHomeStickyHeader.bounds.height, 45)
                let topHeight: CGFloat = 36 + 16
                let availableHeight = view.bounds.height
                    - view.safeAreaInsets.top
                    - view.safeAreaInsets.bottom
                    - tabHeight
                    - topHeight
                return availableHeight
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionHome(rawValue: indexPath.section)
        switch sectionType {
        case .bannerSwitch:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerSwitchTableViewCell.identifier, for: indexPath) as? BannerSwitchTableViewCell else { return UITableViewCell() }
            if let banners = viewModel.homeData.value?.banners {
                cell.banners = banners
            }
            
            //            if viewModel?.showEntryMenuSkeleton == true {
            //                guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonUtilityTableViewCell.identifier(), for: indexPath) as? SkeletonUtilityTableViewCell else { return UITableViewCell() }
            //                cell.showUtilitySkeleton(section: .userSettings, serviceType: viewModel?.userBonusesBoarding?.brandServiceType)
            //                return cell
            //            }
            return cell
        case .detailUserCard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailUserCardTableViewCell.identifier, for: indexPath) as? DetailUserCardTableViewCell else { return UITableViewCell() }
            if let detailUserCards = viewModel.homeData.value?.detailUserCards {
                cell.detailUserCards = detailUserCards
            }
            return cell
        case .sellingService:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SellingServiceTableViewCell.identifier, for: indexPath) as? SellingServiceTableViewCell else { return UITableViewCell() }
            if let sellingServices = viewModel.homeData.value?.sellingServices {
                cell.sellingServices = sellingServices
            }
            return cell
        case .recommendationProduct:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPagerTableViewCell.identifier, for: indexPath) as? ProductPagerTableViewCell else { return UITableViewCell() }
               if let tabs = viewModel.homeData.value?.tabsHomeMenu {
                   let productsDict = viewModel.products.value
                   cell.isGridScrollEnabled = { false }
                   cell.configure(categories: tabs, productsDict: productsDict)
                   cell.didScrollToPage = { [weak self] index in
                       self?.tabHomeStickyHeader.setSelectedTab(index)
                   }
                   cell.didSelectProduct = { [weak self] product in
                       let detailVC = ProductDetailViewCtr()
                       detailVC.product = product
                       self?.navigationController?.pushViewController(detailVC, animated: true)
                   }
               }
               return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .cyan
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == SectionHome.recommendationProduct.rawValue ? 45 : .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SectionHome.recommendationProduct.rawValue {
            return tabHomeStickyHeader
        }
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerRect = tableView.rectForHeader(inSection: SectionHome.recommendationProduct.rawValue)
           let headerFrame = tableView.convert(headerRect, to: view)

           let wasSticky = isHeaderSticky
           isHeaderSticky = headerFrame.origin.y <= view.safeAreaInsets.top

           if wasSticky != isHeaderSticky {
               UIView.performWithoutAnimation {
                   tableView.beginUpdates()
                   tableView.endUpdates()
               }

               if let pagerCell = tableView.cellForRow(at: IndexPath(row: 0, section: SectionHome.recommendationProduct.rawValue)) as? ProductPagerTableViewCell {
                   pagerCell.setGridScrollEnabled(isHeaderSticky)
               }
           }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 200 {
            if let tabs = viewModel.homeData.value?.tabsHomeMenu {
                let currentTabId = tabs[tabHomeStickyHeader.selectedIndex].id
                viewModel.loadMoreProducts(for: currentTabId, pageSize: 4)
                print("📌 ScrollView did scroll with currentTabId:", currentTabId, " (selectedIndex =", tabHomeStickyHeader.selectedIndex, ")")
            }
        }
    }
}
