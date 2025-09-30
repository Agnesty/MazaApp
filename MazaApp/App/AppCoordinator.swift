//
//  AppCoordinator.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 30/09/25.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if AuthRepositoryService.shared.currentUser() != nil {
            showMain()
        } else {
            showSignIn()
        }
    }
    
    func showSignIn() {
        let repo = AuthRepositoryService.shared
        let useCase = AuthUseCase(repository: repo)
        let viewModel = AuthViewModel(useCase: useCase)
        
        let signInVC = SignInViewCtr(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: signInVC)
        nav.navigationBar.prefersLargeTitles = true
        signInVC.navigationItem.largeTitleDisplayMode = .always
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    
    func showMain() {
        let tabBar = TabBarViewCtr()
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
    
    func logout() {
        AuthRepositoryService.shared.logout()
        showSignIn()
    }
}
