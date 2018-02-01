//
//  AppModules.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

//MARK: - Application modules
enum AppModules: String, ViperitModule {
    case start
    case visit
    case visitLog
    case traplineSelect
    case stationSelect
    case newVisit
    case settings
    case menu
    case datePicker
    case sideMenu
    case listPicker
    case route
    case map
    case routeDashboard
    case loader
    case newRoute
    case visitHistory
    
    var viewType: ViperitViewType {
        return .code
    }
}
