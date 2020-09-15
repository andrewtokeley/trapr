//
//  RoundedButton.swift
//  trapr
//
//  Created by Andrew Tokeley on 4/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    convenience init(title:String, target: Any, action:Selector) {
        self.init()
        self.addTarget(target, action: action, for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .trpLabelSmall
        self.clipsToBounds = true
        isSelected(false)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2.0
        layer.masksToBounds = true
    }
        
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title?.uppercased(), for: state)
    }
    
    func isSelected(_ selected: Bool) {
        if selected {
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .trpButtonEnabled
        } else {
            self.setTitleColor(.trpHighlightColor, for: .normal)
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.trpButtonEnabled.cgColor
        }
    }
}
