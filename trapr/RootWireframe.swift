//
//  RootWireframe.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class RootWireframe
{
    // Launches the app with the board module
    func presentHome(in window: UIWindow) {
        
        let homeWireframe = HomeWireframe()
        homeWireframe.presentView(in: window)
        
    }
}
