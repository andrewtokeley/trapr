//
//  OptionItem.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class OptionItem {
    var title: String
    var isEnabled: Bool = true
    var isDestructive: Bool = false
    
    init(title: String, isEnabled: Bool) {
        self.title = title
        self.isEnabled = isEnabled
    }
    
    convenience init(title: String, isEnabled: Bool, isDestructive: Bool) {
        self.init(title: title, isEnabled: isEnabled)
        self.isDestructive = isDestructive
    }
}
