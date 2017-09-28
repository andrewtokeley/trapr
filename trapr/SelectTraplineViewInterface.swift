//
//  SelectTraplineViewInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 28/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol SelectTraplineViewInterface {
    
    func setTitle(title: String)
    func displayTraplines(selected: [Trapline]?, available: [Trapline]?)
    func displayWarningMessage(message: String)
}
