//
//  Extensions.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 10/02/25.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: CGColor) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundTopCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.topLeft, .topRight], radius: 6, borderColor: UIColor.clear.cgColor)
    }
    
    func roundCardTopCorners(radius: Int = 0, borderColor: CGColor = UIColor.clear.cgColor) {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.topLeft, .topRight], radius: CGFloat(radius), borderColor: borderColor)
    }
    
    func roundBottomCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 14, borderColor: UIColor.clear.cgColor)
    }
    
    func roundCardBottomCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 14, borderColor: UIColor.clear.cgColor)
    }
    
    func roundBottomRightCorners(cornerRadius: CGFloat = 14) {
        self.layer.cornerRadius = cornerRadius
        self.roundCorners(corners: [.bottomRight], radius: 14, borderColor: UIColor.clear.cgColor)
    }
    
    func roundBottomLeftCorners() {
        self.layer.cornerRadius = 14
        self.roundCorners(corners: [.bottomLeft], radius: 14, borderColor: UIColor.clear.cgColor)
    }
    
    func roundTopLeftCorners() {
        self.layer.cornerRadius = 14
        self.roundCorners(corners: [.topLeft], radius: 14, borderColor: UIColor.clear.cgColor)
    }
    
    func unroundAllCorners() {
        self.layer.cornerRadius = 0
        self.roundCorners(corners: [.allCorners], radius: 0, borderColor: UIColor.clear.cgColor)
    }
    
    func roundAllCorners() {
        self.layer.cornerRadius = 6
        self.roundCorners(corners: [.allCorners], radius: 6, borderColor: UIColor.clear.cgColor)
    }
    
    func makeRounded(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = false
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func CustomCardView(
        shadowColor: CGColor,
        shadowOffset: CGSize,
        shadowOpacity: Float,
        shadowRadius: CGFloat,
        cornerRadius: CGFloat) {
        // cardView shadow
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = cornerRadius
    }
    
    func showLoadingHUD() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }

    func hideLoadingHUD() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
