//
//  MultiselectTableViewHeader.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol TableViewHeaderWithActionDelegate {
    func tableViewHeaderWithAction(_ tableViewHeaderWithAction: TableViewHeaderWithAction, actionButtonClickedForSection section: Int)
}

class TableViewHeaderWithAction: UITableViewHeaderFooterView {
    
    var delegate: TableViewHeaderWithActionDelegate?
    var section: Int = 0
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.trpTableViewSectionHeading
        button.addTarget(self, action: #selector(actionButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(actionButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.textIndentMargin)
        
        if (actionButton.imageView?.image == nil) {
            actionButton.autoPinEdge(toSuperviewEdge: .bottom)
        } else {
            actionButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: LayoutDimensions.smallSpacingMargin)
        }
    }
    
    func actionButtonClick(sender: UIButton) {
        delegate?.tableViewHeaderWithAction(self, actionButtonClickedForSection: self.section)
    }
    
}

