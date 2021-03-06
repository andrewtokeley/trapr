//
//  RouteTableViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol RouteTableViewCellDelegate {
    func didClickRouteName(_ sender: RouteTableViewCell)
    func didClickLastVisited(_ sender: RouteTableViewCell)
    func didClickVisit(_ sender: RouteTableViewCell)
    func didClickRouteImage(_ sender: RouteTableViewCell)
}

class RouteTableViewCell: UITableViewCell {
    var delegate: RouteTableViewCellDelegate?
    
    @IBOutlet weak var routeNameButton: UIButton!
    @IBOutlet weak var visitButton: UIButton!
    @IBOutlet weak var lastVisitedButton: UIButton!
    @IBOutlet weak var routeImageView: UIImageView!
    
    @IBAction func visitButtonClick(_ sender: UIButton) {
        delegate?.didClickVisit(self)
    }
    
    @IBAction func lastVisitedButtonClick(_ sender: UIButton) {
        delegate?.didClickLastVisited(self)
    }

    @IBAction func routeNameButtonClicked(_ sender: UIButton) {
        delegate?.didClickRouteName(self)
    }
    
    @IBAction func lastVisitedImageButtonClicked(_ sender: UIButton) {
        delegate?.didClickLastVisited(self)
    }
    
    @objc func imageClicked(sender: UIImageView) {
        delegate?.didClickRouteImage(self)
    }
    
    override func awakeFromNib() {
        visitButton.backgroundColor = UIColor.trpHighlightColor
        visitButton.setTitleColor(UIColor.white, for: .normal)
        
        let tap = UITapGestureRecognizer(target:self, action: #selector(imageClicked(sender:)))
        routeImageView.addGestureRecognizer(tap)
    }
}
