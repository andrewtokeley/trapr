//
//  RouteSetupData.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class RouteSetupData {
    
    /**
     The route being edited. Set to nil if creating a new Route.
     */
    var route: Route?
    var delegate: RouteModuleDelegate?
}

protocol RouteModuleDelegate {
    func routeModule(didUpdateRoute: Route)
    func routeModule(didCreateRoute: Route)
}
