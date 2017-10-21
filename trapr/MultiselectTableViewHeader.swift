//
//  MultiselectTableViewHeader.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum MultiselectToggle: Int {
    case selectAll
    case selectNone
    case none
    
    var textForState: String {
        switch self {
        case .selectAll: return "Select All"
        case .selectNone: return "Select None"
        case .none: return ""
        }
    }
}

protocol MultiselectTableViewHeaderDelegate {
    func multiselectTableViewHeader(_ header: MultiselectTableViewHeader, toggledSection: Int)
}

class MultiselectTableViewHeader: UITableViewHeaderFooterView {

    var delegate: MultiselectTableViewHeaderDelegate?
    var section: Int = 0
    
    lazy var multiselectToggle: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        button.titleLabel?.font = UIFont.trpTableViewSectionHeading
        button.addTarget(self, action: #selector(multiselectToggleClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(multiselectToggle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        multiselectToggle.autoPinEdge(toSuperviewEdge: .right)
        multiselectToggle.autoPinEdge(toSuperviewEdge: .bottom)
        multiselectToggle.autoSetDimension(.width, toSize: 100)
    }
    
    func setState(state: MultiselectToggle) {
        self.multiselectToggle.setTitle(state.textForState, for: .normal)
        multiselectToggle.isEnabled = state != .none
    }
    
    func multiselectToggleClick(sender: UIButton) {

        delegate?.multiselectTableViewHeader(self, toggledSection: self.section)
    }
    
}
