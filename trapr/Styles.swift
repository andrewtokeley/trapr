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
    static func setAppearances() {
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.tintColor = UIColor.trpNavigationBarTint
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.trpNavigationBar
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //        let labelAppearance = UILabel.appearance()
        //        labelAppearance.textColor = UIColor.mmTextDark
        
    }
}
