//
//  SectionStripView.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SectionStripView: UIView {

    var delegate: SectionStripViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        titleLabel.font = UIFont.trpTableViewSectionHeading
        actionButton.titleLabel?.font = UIFont.trpTableViewSectionHeading
        self.backgroundColor = UIColor.trpSectionStrip
        
        actionButton.addTarget(self, action: #selector(actionButtonTap(sender:)), for: .touchUpInside)
    }
    
    func actionButtonTap(sender: UIButton) {
        delegate?.sectionStrip(self, didSelectActionButton: actionButton)
    }
}
