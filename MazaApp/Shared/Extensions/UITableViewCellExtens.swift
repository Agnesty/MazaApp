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
