//
//  SelectTraplineViewController.swift
//  trapr
//
//  Created by Andrew Tokeley  on 28/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SelectTraplineViewController: UIViewController, SelectTraplineViewInterface {
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func displayTraplines(selected: [Trapline]?, available: [Trapline]?) {
        
    }
    
    func displayWarningMessage(message: String) {
        
    }
}
