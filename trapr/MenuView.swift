//
//  MenuView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 6/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class MenuView: UIView {
    
    var presenter: MenuPresenter?
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(closeMenu(sender:)))
        background.addGestureRecognizer(backgroundTap)
        
        userEmail.textColor = UIColor.trpTextLight
        userName.textColor = UIColor.trpTextLight
        headerView.backgroundColor = UIColor.trpMenuBar
    }
    
    func closeMenu(sender: UIImageView) {
        presenter?.didSelectClose()
    }
}
