//
//  RouteDashboardSetup.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class RouteDashboardSetup {
    var route: Route?
    var delegate: RouteDashboardDelegate?
}

protocol RouteDashboardDelegate {
    func routeDashboard(didUpdate route: Route)
    func routeDashboard(didCreate route: Route)
}
