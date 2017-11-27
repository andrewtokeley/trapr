//
//  VisitSummaryTableViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 27/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class VisitSummaryTableViewCell: UITableViewCell {
    
    var delegate: VisitSummaryTableViewCellDelegate?
    
    @IBOutlet weak var poisonCount: UILabel!
    @IBOutlet weak var killCount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var sentImage: UIImageView!
    
    @IBOutlet weak var routeNameButton: UIButton!
    @IBAction func routeNameButtonClicked(sender: UIButton) {
        
    }
    
}
