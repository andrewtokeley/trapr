//
//  UIFontExtension.swift
//  trapr
//
//  Created by Andrew Tokeley  on 15/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    public static var trpLabel: UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }
    
    public static var trapText: UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }
    
    public static var trapTextSmall: UIFont {
        return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    public static var trapTableViewSectionHeading: UIFont {
        return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
}
