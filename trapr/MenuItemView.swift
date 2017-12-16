//
//  MenuItemView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 14/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class MenuItemView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(image)
        self.addSubview(label)
    }
    
    convenience init(item: SideBarMenuItem) {
        self.init()
        self.image.image = item.image
        self.label.text = item.name
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //menuItem.autoSetDimension(.height, toSize: 100)
        
        image.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        image.autoSetDimension(.width, toSize: LayoutDimensions.spacingMargin)
        image.autoSetDimension(.height, toSize: LayoutDimensions.spacingMargin)
        image.autoAlignAxis(.horizontal, toSameAxisOf: self)

        label.autoPinEdge(.left, to: .right, of: image, withOffset: LayoutDimensions.spacingMargin * 2)
        label.autoAlignAxis(.horizontal, toSameAxisOf: self)
        label.autoPinEdge(toSuperviewMargin: .right)
    }
    
    public var isSelected: Bool = false {
        didSet {
            self.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white
        }
    }
    
    //MARK: - Subviews
    
//    lazy var menuItem: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.addSubview(self.image)
//        view.addSubview(self.label)
//
//        return view
//    }()
    
    lazy var image: UIImageView = {
        
        // default image
        let image = UIImageView(image: UIImage(named: "close"))
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    lazy var label: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.trpLabel
        label.textColor = UIColor.trpTextDark
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    
}
