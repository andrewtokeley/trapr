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
    case traplineSelect
    case stationSelect
    case newVisit
    case settings
    case menu
    case datePicker
    
    var viewType: ViperitViewType {
        switch self {
        case .visit:
            return .nib
        default:
            return .code
        }
    }
}
