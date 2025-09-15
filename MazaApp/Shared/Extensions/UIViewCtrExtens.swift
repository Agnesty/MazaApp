//
//  UIViewCtrExtens.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 03/09/25.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        }))
        present(alert, animated: true)
    }
}
