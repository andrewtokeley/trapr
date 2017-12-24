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
        return UIFont.systemFont(ofSize: 25, weight: UIFontWeightBold)
    }
    
    /**
     Font definition, 30 Bold
     */
    public static var trpLabelBoldLarge: UIFont {
        return UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
    }
    
    /**
     Font definition, System size
     */
    public static var trpLabelNormal: UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }
//
//    public static var trpText: UIFont {
//        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
//    }

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
