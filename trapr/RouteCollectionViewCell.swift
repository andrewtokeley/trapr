//
//  RouteCollectionViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class RouteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var routeTrapLinesLabel: UILabel!
    @IBOutlet weak var daysSinceLastVisitLabel: UILabel!
    
    override func awakeFromNib() {
        
        routeNameLabel?.textColor = UIColor.trpTextHighlight
        routeNameLabel?.font = UIFont.trpText
        
        routeTrapLinesLabel?.textColor = UIColor.trpTextDark
        routeTrapLinesLabel?.font = UIFont.trpText

        daysSinceLastVisitLabel?.textColor = UIColor.trpTextDark
        daysSinceLastVisitLabel?.font = UIFont.trpTextSmall
        
    }
}
