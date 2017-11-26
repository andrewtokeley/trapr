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
    static let DATE_FORMAT_DAY = "EEEE"
    
    static func setAppearances() {
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.tintColor = UIColor.white
        barButtonItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.trpNavigationBar
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.textColor = UIColor.trpTextDark
        
        let stepperAppearance = UIStepper.appearance()
        stepperAppearance.tintColor = UIColor.trpMenuBar
        
        let buttonAppearance =  UIButton.appearance()
        buttonAppearance.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        buttonAppearance.setTitleColor(UIColor.trpButtonDisabled, for: .disabled)
        
        let alertActionViewControllerView = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertActionViewControllerView.tintColor = UIColor.trpTextHighlight
        
    }
}
