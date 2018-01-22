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
    
    
    /**
     Font definition, 25 Bold
     */
    public static var trpLabelBoldMedium: UIFont {
        return UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
    }
    
    /**
     Font definition, 30 Bold
     */
    public static var trpLabelBoldLarge: UIFont {
        return UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
    }
    
    /**
     Font definition, System size
     */
    public static var trpLabelNormal: UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }

    public static var trpAppNameFont: UIFont {
        return UIFont.init(name: "Helvetica", size: 25) ?? trpLabelBoldLarge
    }

    /**
     Font definition, Small system size
     */
    public static var trpLabelSmall: UIFont {
        return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    /**
     Font definition for tableview section headings - Small system size
     */
    public static var trpTableViewSectionHeading: UIFont {
        return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
}
