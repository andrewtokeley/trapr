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

    public class var trpNavigationBarTint: UIColor {
        return UIColor.white
    }
    
    public class var trpBackground: UIColor {
        return UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    }
    
    public class var trpVisitTileBackground: UIColor {
        return UIColor.white
    }
    
    public class var trpText: UIColor {
        return UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
    }
    
}
