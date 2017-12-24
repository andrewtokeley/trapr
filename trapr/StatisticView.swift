//
//  StatisticCollectionViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 20/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class StatisticView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statisticLabel: UILabel!
    @IBOutlet weak var varianceLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    
    func showDivider(show: Bool) {
        self.divider.isHidden = !show
    }
    
    var statistic: String? {
        willSet {
            statisticLabel.text = newValue
        }
    }
    
    var heading: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    var variance: Double = 0 {
        willSet {
            varianceLabel.text = String(newValue)
        }
    }
    
    override func awakeFromNib() {
        
        titleLabel?.textColor = UIColor.trpTextDark
        titleLabel?.font = UIFont.trpLabelSmall
        
        statisticLabel?.textColor = UIColor.trpTextDark
        statisticLabel?.font = UIFont.trpLabelBoldMedium
        
        varianceLabel?.textColor = UIColor.trpTextDark
        varianceLabel?.font = UIFont.trpLabelSmall

        
    }
}
