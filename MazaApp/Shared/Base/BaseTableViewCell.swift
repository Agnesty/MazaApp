//
//  BaseTableViewCell.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 10/02/25.
//

import UIKit

public enum CornerType {
    case none
    case top
    case bottom
    case all
}

class BaseTableViewCell: UITableViewCell {
    public var tableview: UITableView?
    public var indexPath: IndexPath?
    public var hasHeader: Bool = false
    public var needBottomShadow: Bool = false
    public var forceNoShadow: Bool = false
    
    private var cornerType: CornerType = .none
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        clipsToBounds = false
        self.configView()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        manuallyLayout()
        if let tv = tableview, let index = indexPath {
            addShadowToCellInTableView(tv: tv, indexPath: index, cornerRadius: 6, hasHeader: hasHeader, needBottomShadow: needBottomShadow, forceNoShadow: forceNoShadow)
        }
    }
    
    private func manuallyLayout() {
        switch cornerType {
        case .none:
            self.unroundAllCorners()
        case .top:
            self.roundTopCorners()
        case .bottom:
            self.roundBottomCorners()
        default:
            self.roundAllCorners()
        }
    }
    
    open func setCornerType(_ type: CornerType) {
        cornerType = type
    }
    
    open func configCellWithData(data: Any?) {
        
    }
    
    func configView() {
        
    }

    // MARK: - Reuse identifer
    class var identifier: String {
        get {
            let mirror = Mirror(reflecting: self)
            return "\(String(describing: mirror.subjectType).replacingOccurrences(of: ".Type", with: ""))ID"
        }
    }

}
