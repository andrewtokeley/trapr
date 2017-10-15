//
//  MenuItem.swift
//  trapr
//
//  Created by Andrew Tokeley  on 25/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum MenuItem: Int {
    case Home = 0
    case Map
    case Sync
    case Settings
    case Divider
    
    var isDivider: Bool {
        return self == .Divider
    }
    
    var name: String {
        switch self {
        case .Home: return "Home"
        case .Map: return "Map"
        case .Settings: return "Settings"
        case .Sync: return "Synchronize Data"
        default: return "-"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .Home: return UIImage(named: "home")
        case .Map: return  UIImage(named: "map")
        case .Settings: return  UIImage(named: "settings")
        case .Sync: return  UIImage(named: "sync")
        default: return nil
        }
    }
}
