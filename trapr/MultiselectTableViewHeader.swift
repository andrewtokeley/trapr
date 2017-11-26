//
//  MultiselectTableViewHeader.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum MultiselectOptions: Int {
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
    func multiselectTableViewHeader(_ header: MultiselectTableViewHeader, multiselectOptionClicked: MultiselectOptions, section: Int)
}

class MultiselectTableViewHeader: TableViewHeaderWithAction {

    var multiselectDelegate: MultiselectTableViewHeaderDelegate?
    var currentMultiselectOption: MultiselectOptions = .none
    
    //var section: Int = 0
    
//    lazy var multiselectToggle: UIButton = {
//        let button = UIButton()
//        button.titleLabel?.textAlignment = .right
//        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
//        button.titleLabel?.font = UIFont.trpTableViewSectionHeading
//        button.addTarget(self, action: #selector(multiselectToggleClick(sender:)), for: .touchUpInside)
//        return button
//    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        //contentView.addSubview(multiselectToggle)

        // set default initial state
        displayMultiselectOption(option: self.currentMultiselectOption)
    }
    
    convenience init(reuseIdentifier: String?, initialState: MultiselectOptions) {
        self.init(reuseIdentifier: reuseIdentifier)
        displayMultiselectOption(option: initialState)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        multiselectToggle.autoPinEdge(toSuperviewEdge: .right)
//        multiselectToggle.autoPinEdge(toSuperviewEdge: .bottom)
//        multiselectToggle.autoSetDimension(.width, toSize: 100)
//    }
    
    func displayMultiselectOption(option: MultiselectOptions) {
        print("set state to = \(option)")
        self.currentMultiselectOption = option
        self.actionButton.setTitle(option.textForState, for: .normal)
        self.actionButton.isEnabled = option != .none
    }
    
    override func actionButtonClick(sender: UIButton) {
        super.actionButtonClick(sender: sender)
     
        // tell delegate that option clicked
        multiselectDelegate?.multiselectTableViewHeader(self, multiselectOptionClicked: self.currentMultiselectOption, section: self.section)
        let newState: MultiselectOptions = (self.currentMultiselectOption == .selectAll) ? .selectNone : .selectAll
        displayMultiselectOption(option: newState)
    }
    
}
