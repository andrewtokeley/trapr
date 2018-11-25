//
//  MenuItem.swift
//  trapr
//
//  Created by Andrew Tokeley  on 25/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum SideBarMenuItem: Int {
    case Home = 0
    case Map
    case Sync
    case Settings
    case SignOut
    case SignIn
    case Administration
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
        case .Administration: return "Administration"
        case .SignOut: return "Sign Out"
        case .SignIn: return "Sign In"
        default: return "-"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .Home: return UIImage(named: "home")
        case .Map: return  UIImage(named: "map")
        case .Settings: return  UIImage(named: "settings")
        case .Administration : return  UIImage(named: "settings")
        case .Sync: return  UIImage(named: "sync")
        case .SignOut: return  UIImage(named: "exit")
        case .SignIn: return  UIImage(named: "settings")?.changeColor(UIColor.white)
        default: return nil
        }
    }
}
