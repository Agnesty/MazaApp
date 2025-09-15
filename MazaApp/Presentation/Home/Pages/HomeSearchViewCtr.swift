//
//  HomeSearchViewCtr.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 10/02/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeSearchViewCtr: BaseViewController {

    private let viewModel = HomeViewModel.shared
    private let searchHistoryDB = SearchHistoryDB.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let topBarView = TopBarView()
    
    private let searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        return icon
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search"
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        return tf
    }()
    
    private let moreIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "ellipsis"))
        iv.tintColor = .black
        iv.isUserInteractionEnabled = true
        iv.transform = CGAffineTransform(rotationAngle: .pi/2)
        return iv
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    // Untuk swipe delete
    private var currentItems: [Product] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        loadHistory()
        tableView.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(topBarView)
        view.addSubview(searchBarView)
        view.addSubview(moreIcon)
        view.addSubview(tableView)
        searchBarView.addSubview(searchIcon)
        searchBarView.addSubview(searchTextField)
        
        topBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        searchBarView.snp.makeConstraints {
            $0.centerY.equalTo(topBarView.snp.centerY)
            $0.leading.equalTo(topBarView.snp.leading).offset(50)
            $0.trailing.equalTo(moreIcon.snp.leading).offset(-8)
            $0.height.equalTo(36)
        }
        
        searchIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(searchIcon.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        moreIcon.snp.makeConstraints {
            $0.centerY.equalTo(searchBarView.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(8)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        topBarView.setLeftVisibility(showBack: true, showTitle: false)
        topBarView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Tap gesture untuk menu more
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMoreMenu))
        moreIcon.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        // Search keyword -> filter products
        searchTextField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] keyword in
                self?.viewModel.searchProducts(keyword: keyword)
            })
            .disposed(by: disposeBag)
        
        // Enter key -> insert history
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self else { return }
                
                // Simpan keyword ke history
                self.searchHistoryDB.insert(keyword: keyword)
                self.loadHistory()
                
                // Jika ada product exact match → buka detail
                if let matchedProduct = self.viewModel.searchResult.value.first(where: { $0.productName.lowercased() == keyword.lowercased() }) {
                    let detailVC = ProductDetailViewCtr()
                    detailVC.product = matchedProduct
                    detailVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        // Combine history + search results
        let combined = Observable.combineLatest(viewModel.historyRelay, viewModel.searchResult) { history, results -> [Product] in
            if results.isEmpty {
                return history.map {
                    Product(
                        id: -1,
                        imageName: "",
                        imageURL: "",
                        discountPercentage: "",
                        productName: $0,
                        priceAfterDiscount: 0,
                        originalPrice: 0,
                        promoText: "",
                        ratingText: "",
                        storeName: "",
                        description: ""
                    )
                }
            } else {
                return results
            }
        }
        
        // Bind ke tableView
        combined
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { [weak self] index, item, cell in
                cell.textLabel?.text = item.productName
                cell.textLabel?.textColor = (item.id == -1) ? .gray : .black
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Load History
    private func loadHistory() {
        let all = searchHistoryDB.fetchAll()
        viewModel.historyRelay.accept(all)
    }
    
    // MARK: - Clear History
    @objc private func clearHistory() {
        searchHistoryDB.deleteAll()
        loadHistory()
    }
    
    // MARK: - More menu
    @objc private func showMoreMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Clear History", style: .destructive, handler: { [weak self] _ in
            self?.clearHistory()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

extension HomeSearchViewCtr: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let combinedItems: [Product]
        if viewModel.searchResult.value.isEmpty {
            // Tampilkan history jika hasil search kosong
            combinedItems = viewModel.historyRelay.value.map {
                Product(
                    id: -1,
                    imageName: "",
                    imageURL: "",
                    discountPercentage: "",
                    productName: $0,
                    priceAfterDiscount: 0,
                    originalPrice: 0,
                    promoText: "",
                    ratingText: "",
                    storeName: "",
                    description: ""
                )
            }
        } else {
            // Gunakan hasil search
            combinedItems = viewModel.searchResult.value
        }

        guard indexPath.row < combinedItems.count else { return }
        let product = combinedItems[indexPath.row]

        if product.id == -1 {
            // History tapped → isi search bar & trigger search
            searchTextField.text = product.productName
            viewModel.searchProducts(keyword: product.productName)
        } else {
            // Product tapped → buka ProductDetailViewCtr
            let detailVC = ProductDetailViewCtr()
            detailVC.product = product
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let history = viewModel.historyRelay.value
        guard indexPath.row < history.count else { return nil }
        let keyword = history[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.searchHistoryDB.delete(keyword: keyword)
            
            DispatchQueue.main.async {
                let updatedHistory = self.searchHistoryDB.fetchAll()
                self.viewModel.historyRelay.accept(updatedHistory)
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

