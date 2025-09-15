//
//  UITableViewCellExtens.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 10/02/25.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func addShadowToCellInTableView(tv: UITableView, indexPath: IndexPath, cornerRadius: CGFloat, hasHeader: Bool = false, needBottomShadow: Bool = false, forceNoShadow: Bool = false) {
        let isFirstRow = (indexPath.row == 0)
        let isLastRow = (indexPath.row == tv.numberOfRows(inSection: indexPath.section) - 1)
        
        backgroundColor = UIColor.clear
//        let layer: CAShapeLayer = CAShapeLayer()
//        let path: CGMutablePath = CGMutablePath()
//        var bounds = self.bounds
//
//        if isFirstRow && isLastRow {
//            path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
//        }else if isFirstRow {
//            path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
//            path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
//            path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
//            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
//        }else if isLastRow {
//            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
//            path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
//            path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
//            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
//        }else {
////            path.addRoundedRect(in: bounds, cornerWidth: 0, cornerHeight: 0)
//
//            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
//            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
//            path.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
//            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
//        }
//
//        layer.path = path
//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.fillColor = UIColor.white.cgColor
//
//        layer.masksToBounds = false
//        layer.shadowPath = layer.path
//        layer.shadowRadius = 4
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.5
        
//        let bgView = UIView(frame: bounds)
//        bgView.backgroundColor = UIColor.white
//        bgView.layer.insertSublayer(layer, at: 0)
//        backgroundColor = UIColor.clear
//        backgroundView = bgView
        
        let padding: CGFloat = 5
        var frame: CGRect = CGRect(x: padding, y: -cornerRadius, width: bounds.size.width - 2*padding, height: bounds.size.height + 2*cornerRadius)
        if isFirstRow && isLastRow {
            if hasHeader {
                if forceNoShadow {
                    frame = CGRect(x: padding, y: -cornerRadius, width: bounds.size.width - 2*padding, height: bounds.size.height + 2*cornerRadius)
                }else {
                    frame = CGRect(x: padding, y: -cornerRadius, width: bounds.size.width - 2*padding, height: bounds.size.height)
                }
            }else {
                if needBottomShadow {
                    frame = CGRect(x: padding, y: 0, width: bounds.size.width - 2*padding, height: bounds.size.height - cornerRadius)
                }else {
                    frame = CGRect(x: padding, y: 0, width: bounds.size.width - 2*padding, height: bounds.size.height + cornerRadius)
                }
            }
            
        }else if isFirstRow {
            if hasHeader {
                frame = CGRect(x: padding, y: -cornerRadius, width: bounds.size.width - 2*padding, height: bounds.size.height + 2*cornerRadius)
            }else {
                frame = CGRect(x: padding, y: 0, width: bounds.size.width - 2*padding, height: bounds.size.height + cornerRadius)
            }
            
        }else if isLastRow {
            if needBottomShadow {
                frame = CGRect(x: padding, y: -cornerRadius, width: bounds.size.width - 2*padding, height: bounds.size.height)
            }else {
                frame = CGRect(x: padding, y: -cornerRadius, width: bounds.size.width - 2*padding, height: bounds.size.height + 2*cornerRadius)
            }
        }
        
        let bgView = UIView(frame: frame)
        bgView.backgroundColor = UIColor.white
        bgView.CustomCardView(shadowColor: assets.shadowColor, shadowOffset: assets.shadowOffset, shadowOpacity: 1, shadowRadius: 2, cornerRadius: 6)
        backgroundView = bgView
    }
}
