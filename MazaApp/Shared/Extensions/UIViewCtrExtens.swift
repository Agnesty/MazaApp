//
//  UIViewCtrExtens.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 03/09/25.
//

import Foundation
import UIKit
import MBProgressHUD

extension BaseViewController {
    func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        }))
        present(alert, animated: true)
    }
    
    func showLoadingHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
