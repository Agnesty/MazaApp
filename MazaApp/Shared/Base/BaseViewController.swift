//
//  BaseViewController.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 10/02/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        tabBarController?.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController?.tabBar.scrollEdgeAppearance = appearance
        }

        tabBarController?.tabBar.isTranslucent = false
        
//        if let tabBar = tabBarController?.tabBar {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .white
//            
//            tabBar.standardAppearance = appearance
//            //tabBar.scrollEdgeAppearance = appearance
//        }
    }
}

