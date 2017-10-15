//
//  MenuDivider.swift
//  trapr
//
//  Created by Andrew Tokeley  on 14/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class MenuDivider: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.addSubview(line)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        line.autoPinEdge(toSuperviewMargin: .left)
        line.autoPinEdge(toSuperviewMargin: .right)
        line.autoSetDimension(.height, toSize: 1)
        line.autoAlignAxis(.horizontal, toSameAxisOf: self)
    }
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
}
