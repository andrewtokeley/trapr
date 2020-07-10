//
//  Styles.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class Styles {
    
    static let DATE_FORMAT_LONG = "MMM dd, yyyy"
    static let DATE_FORMAT_TIME = "hh:mm"
    static let DATE_FORMAT_DAY = "EEEE"
    static let DATE_FORMAT_LONG_NO_SPACES = "MMM_dd_yyyy"
    
    static func setAppearances() {
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.tintColor = UIColor.trpHighlightColor
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.trpHighlightColor], for: UIControl.State.normal)
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.trpNavigationBar
        navigationBarAppearance.isTranslucent = true
        navigationBarAppearance.tintColor = UIColor.trpHighlightColor
        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.trpHighlightColor]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.trpHighlightColor]
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.textColor = UIColor.trpTextDark
        
//        let stepperAppearance = UIStepper.appearance()
//        stepperAppearance.tintColor = UIColor.trpMenuBar
        
//        let gmStepper = GMStepper.appearance()
//        gmStepper.borderColor = .trpHighlightColor
//        gmStepper.borderWidth = 1
//        gmStepper.labelFont = .trpLabelNormal
//        gmStepper.labelTextColor = .trpHighlightColor
//        gmStepper.labelBackgroundColor = .clear
//        gmStepper.buttonsBackgroundColor = .trpHighlightColor
//
        let buttonInNavigationBar = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonInNavigationBar.setTitleColor(UIColor.trpTextHighlight, for: .normal)
        buttonInNavigationBar.setTitleColor(UIColor.lightGray, for: .disabled)
        
        let textFieldInNavigationBar = UITextField.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        textFieldInNavigationBar.textColor = UIColor.trpTextHighlight
        
        let alertActionViewControllerView = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertActionViewControllerView.tintColor = UIColor.trpTextHighlight
        
        if let menuControllerButton = NSClassFromString("UICalloutBarButton") as? UIButton.Type {
            menuControllerButton.appearance().setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            menuControllerButton.appearance().setTitleColor(UIColor.trpTextHighlight, for: UIControl.State.highlighted)
        }
    }
}
