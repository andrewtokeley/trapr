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
    public class var trpChartBarStack1: UIColor {
        return UIColor.trpNavigationBar
    }
    
    public class var trpChartBarStack2: UIColor {
        return UIColor(red: 147/255, green: 196/255, blue: 125/255, alpha: 1)
    }
    
    public class var trpChartBarStack3: UIColor {
        return UIColor(red: 182/255, green: 215/255, blue: 168/255, alpha: 1)
    }
    
    /**
     Use for poison count barchart
    */
    public class var trpChartBarStack4: UIColor {
        return UIColor(red: 36/255, green: 192/255, blue: 165/255, alpha: 1)
    }
    
    public class var trpStackChartColors: [UIColor] {
        return [UIColor.trpChartBarStack1, UIColor.trpChartBarStack2, UIColor.trpChartBarStack3]
    }
    
    //MARK: - App colour scheme
    public class var trpChartGridlines: UIColor {
        return UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    }
    
    public class var trpButtonBackgroundTransparent: UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    }
    
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
