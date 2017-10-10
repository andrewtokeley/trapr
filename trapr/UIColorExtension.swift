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
    
    public class var trpNavigationBar: UIColor {
        return UIColor(red: 18/255, green: 108/255, blue: 19/255, alpha: 1)
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
}
