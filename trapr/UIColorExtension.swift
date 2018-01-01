//
//  UIColorExtension.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    //MARK: - App colour scheme
    
    public class var trpMapDefaultStation: UIColor {
        return UIColor(red: 61/255, green: 133/255, blue: 198/255, alpha: 1)
    }
    
    public class var trpMapHighlightedStation: UIColor {
        return UIColor.orange
    }
    
    public class var trpNavigationBar: UIColor {
        return UIColor(red: 18/255, green: 108/255, blue: 19/255, alpha: 1) 
    }
    
    public class var trpTextHighlight: UIColor {
        return UIColor(red: 18/255, green: 108/255, blue: 19/255, alpha: 1)
    }
    
    public class var trpSectionStrip: UIColor {
        return UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    }
    
    public class var trpButtonEnabled: UIColor {
        return trpMenuBar
    }
    
    public class var trpButtonDisabled: UIColor {
        return UIColor.lightGray
    }
    
    public class var trpNavigationBarTint: UIColor {
        return UIColor.white
    }

    public class var trpNavigationBarTintDisabled: UIColor {
        return UIColor.lightGray
    }

    public class var trpMenuBar: UIColor {
        return UIColor(red: 56/255, green: 118/255, blue: 29/255, alpha: 1)
    }

    public class var trpBackground: UIColor {
        return UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    }
    
    public class var trpVisitTileBackground: UIColor {
        return UIColor.white
    }
    
    public class var trpTextDark: UIColor {
        return UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
    }
    
    public class var trpTextLight: UIColor {
        return UIColor.white
    }
    
    public class var trpDividerLine: UIColor {
        return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    }
    
    public class var trpTextFieldBackground: UIColor {
        return UIColor.white
    }
}
