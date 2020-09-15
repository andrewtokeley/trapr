//
//  NavigationStripDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 9/09/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol NavigationStripDelegate {
    func navigationStrip(_ navigationStrip: NavigationStrip, navigatedToItemAt index: Int)
}
