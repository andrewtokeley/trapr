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

    /**
     Creates a colour object from RGB components represented as intergers in the range 0-255, rather than *CGFloat* values between 0 - 1
     */
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/CGFloat(255), blue: CGFloat(blue)/CGFloat(255), alpha: alpha)
    }
    
    /**
     Returns the colour of a heat map slice give a value and maximum value.
     
     It is assumed there are always 7 equal segments in the heatmap.
     */
    public class func trpHeatColour(value: Int, maximumValue: Int) -> UIColor {

        let NUMBER_OF_COLOUR_SEGMENTS = 7

        // range of each colour segment
        var maxCount = maximumValue
        if maxCount < 7 { maxCount = 7 }
        let range = maxCount / NUMBER_OF_COLOUR_SEGMENTS

        // index within the range
        var index = value / range
        if index > (NUMBER_OF_COLOUR_SEGMENTS - 1) {
            index = NUMBER_OF_COLOUR_SEGMENTS - 1
        } else if index <= 0 {
            index = 0
        }
        return trpHeatColour(heatValue: index)
    }
    
    public class func trpHeatColour(heatValue: Int) -> UIColor {
        switch heatValue {
        case 0: return .trpHeat0
        case 1: return .trpHeat1
        case 2: return .trpHeat2
        case 3: return .trpHeat3
        case 4: return .trpHeat4
        case 5: return .trpHeat5
        case 6: return .trpHeat6
        default: return .trpHeat0
        }
    }
    
    public class var trpHeat0: UIColor {
        return UIColor(72, 150, 87, 1)
    }
    public class var trpHeat1: UIColor {
        return UIColor(158, 205, 110, 1)
    }
    public class var trpHeat2: UIColor {
        return UIColor(221, 238, 151, 1)
    }
    public class var trpHeat3: UIColor {
        return UIColor(254, 255, 198, 1)
    }
    public class var trpHeat4: UIColor {
        return UIColor(249, 225, 150, 1)
    }
    public class var trpHeat5: UIColor {
        return UIColor(237, 147, 100, 1)
    }
    public class var trpHeat6: UIColor {
        return UIColor(198, 64, 50, 1)
    }
    
    public class var trpDefaultTableViewHeaderFooter: UIColor {
        //return UIColor(red:42/255, green: 42/255, blue:44/255,alpha: 1)
        return UIColor(red:0.42, green: 0.42, blue:0.44,alpha: 1)
        
    }
    
    public class var trpProgressBarBackground: UIColor {
        return UIColor(red: 147/255, green: 196/255, blue: 125/255, alpha: 1)
    }
    
    public class var trpStepperBackground: UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 239/255, alpha: 1)
    }
    
    public class var trpProgressBarForeground: UIColor {
        return UIColor.white
        
        
    }
    
    public class var trpChartBarStack1: UIColor {
        return UIColor.trpHighlightColor
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
        return [UIColor.trpChartBarStack1, UIColor.trpChartBarStack2, UIColor.trpChartBarStack3, UIColor.trpChartBarStack4, UIColor.darkGray, UIColor.orange]
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
        //return UIColor(red: 18/255, green: 108/255, blue: 19/255, alpha: 1)
        return trpBackground
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
    
    public class var trpHighlightColor: UIColor {
        return UIColor(red: 18/255, green: 108/255, blue: 19/255, alpha: 1)
    }
    
    public class var trpNavigationBarTint: UIColor {
        return trpHighlightColor
    }

    public class var trpNavigationBarTintDisabled: UIColor {
        return UIColor.lightGray
    }

    public class var trpMenuBar: UIColor {
        return UIColor(red: 56/255, green: 118/255, blue: 29/255, alpha: 1)
    }

    public class var trpBackground: UIColor {
        return UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
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
    
    public class var trpTableViewCellValue1detail: UIColor {
        return UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }
    
    public class var trpDividerLine: UIColor {
        return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    }
    
    public class var trpTextFieldBackground: UIColor {
        return UIColor.white
    }
    
    public class var trpRed: UIColor {
        return UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1)
    }
}
