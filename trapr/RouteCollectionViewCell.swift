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
    
    var delegate: RouteCollectionViewCellDelegate?
    
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var routeTrapLinesLabel: UILabel!
    @IBOutlet weak var daysSinceLastVisitLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var visitButton: UIButton!
    
    @IBAction func visitButtonClick(_ sender: Any) {
        delegate?.routeCollectionViewCellVisitClicked(self)
    }
    
    @IBAction func menuButtonClicked(sender: UIButton) {
        delegate?.routeCollectionViewCellMenuClicked(self)
    }
    
    override func awakeFromNib() {
        
        routeNameLabel?.textColor = UIColor.trpTextHighlight
        routeNameLabel?.font = UIFont.trpLabelNormal
        
        routeTrapLinesLabel?.textColor = UIColor.trpTextDark
        routeTrapLinesLabel?.font = UIFont.trpLabelNormal

        daysSinceLastVisitLabel?.textColor = UIColor.trpTextDark
        daysSinceLastVisitLabel?.font = UIFont.trpLabelSmall
    
        //visitButton.setImage(visitButton.currentImage?.changeColor(UIColor.trpButtonEnabled), for: .normal)
        
        // color the menuImage
        let image = UIImage(named: "show")?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(image, for: .normal)
        menuButton.tintColor = UIColor.trpNavigationBar

    }
}
