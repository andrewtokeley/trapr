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
    
    @IBAction func visitButtonClick(_ sender: Any) {
        delegate?.routeCollectionViewCellVisitClicked(self)
    }
    
    @IBAction func menuButtonClicked(sender: UIButton) {
        
        delegate?.routeCollectionViewCellMenuClicked(self)
        
//        if let numberOfActions = delegate?.routeCollectionViewCell(numberOfActionsFor: self) {
//
//            let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//            for i in 0...numberOfActions - 1 {
//
//                if let actionText = delegate?.routeCollectionViewCell(self, actionTextAt: i) {
//                    var style = UIAlertActionStyle.default
//                    if actionText.lowercased().contains("delete") {
//                        style = UIAlertActionStyle.destructive
//                    }
//                    let action = UIAlertAction(title: actionText, style: style, handler: {
//                        (action) in
//                        self.delegate?.routeCollectionViewCell(self, didSelectActionWith: actionText)
//                    })
//
//                    menu.addAction(action)
//                }
//            }
//
//            // always add a cancel
//            menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//            delegate?.routeCollectionViewCell(hostingViewControllerFor: self).present(menu, animated: true, completion: nil)
//
//        }
    }
    
    override func awakeFromNib() {
        
        routeNameLabel?.textColor = UIColor.trpTextHighlight
        routeNameLabel?.font = UIFont.trpLabelNormal
        
        routeTrapLinesLabel?.textColor = UIColor.trpTextDark
        routeTrapLinesLabel?.font = UIFont.trpLabelNormal

        daysSinceLastVisitLabel?.textColor = UIColor.trpTextDark
        daysSinceLastVisitLabel?.font = UIFont.trpLabelSmall
    
        // color the menuImage
        let image = UIImage(named: "show")?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(image, for: .normal)
        menuButton.tintColor = UIColor.trpNavigationBar

    }
}
