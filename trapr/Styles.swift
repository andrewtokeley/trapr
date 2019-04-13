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
//        navigationBarAppearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationBarAppearance.shadowImage = UIImage()
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.textColor = UIColor.trpTextDark
        
        let stepperAppearance = UIStepper.appearance()
        stepperAppearance.tintColor = UIColor.trpMenuBar
        
//        let buttonAppearance =  UIButton.appearance()
//        buttonAppearance.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
//        buttonAppearance.setTitleColor(UIColor.trpButtonDisabled, for: .disabled)
//        
//        // this is to make sure the action button (Delete) stays white
//        let buttonAppearanceInTableViewCell =  UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
//        buttonAppearanceInTableViewCell.setTitleColor(UIColor.white, for: .normal)
//        
        
//        let buttonAppearanceInTableViewRow =  UIButton.appearance(whenContainedInInstancesOf: [VisitSummaryTableViewCell.self])
//        buttonAppearanceInTableViewRow.setTitleColor(UIColor.orange, for: .normal)
        
//        let buttonInUIBarButtonItem = UIButton.appearance(whenContainedInInstancesOf: [UIBarButtonItem.self])
//        buttonInUIBarButtonItem
        
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

//        let tableViewCellAppearance = UITableViewCell.appearance()
//        tableViewCellAppearance.tintColor = UIColor.trpNavigationBar
    }
}
