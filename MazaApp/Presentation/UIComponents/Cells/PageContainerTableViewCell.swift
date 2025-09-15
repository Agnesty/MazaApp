//
//  PageContainerTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 07/09/25.
//

import UIKit

class PageContainerTableViewCell: BaseTableViewCell {
    
    weak var parentViewController: UIViewController?
    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController] = []
    private var currentIndex = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: UIScreen.main.bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tabs: [TabsHomeMenu], parent: UIViewController) {
        self.parentViewController = parent
        
        // Buat child view controllers untuk setiap tab
        viewControllers = tabs.map { tab in
            let vc = ProductListViewCtr(category: tab.id)
            vc.didSelectProduct = { [weak parent] product in
                let detailVC = ProductDetailViewCtr()
                detailVC.product = product
                parent?.navigationController?.pushViewController(detailVC, animated: true)
            }
            return vc
        }
        
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pvc.dataSource = self
        pvc.delegate = self
        parent.addChild(pvc)
        
        contentView.addSubview(pvc.view)
        pvc.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pvc.didMove(toParent: parent)
        
        // Set halaman awal
        if let first = viewControllers.first {
            pvc.setViewControllers([first], direction: .forward, animated: false)
        }
        
        self.pageViewController = pvc
    }
    
    func setPage(index: Int) {
        guard index >= 0, index < viewControllers.count else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageViewController?.setViewControllers([viewControllers[index]], direction: direction, animated: true)
        currentIndex = index
    }
}

extension PageContainerTableViewCell: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else { return nil }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: currentVC) {
            NotificationCenter.default.post(name: .pageDidChange, object: index)
            currentIndex = index
        }
    }
}

extension Notification.Name {
    static let pageDidChange = Notification.Name("pageDidChange")
}

