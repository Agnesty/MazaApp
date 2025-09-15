//
//  BaseCollectionViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 16/02/25.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell {
    
    public var indexPath: IndexPath?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    public class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public class var identifier: String {
        return String(describing: self)
    }
    
    open func configView() {
        
    }
    
    open func configCellWithData(data: Any?) {
        
    }
    
}
