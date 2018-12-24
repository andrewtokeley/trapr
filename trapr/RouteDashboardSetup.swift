//
//  RouteDashboardSetup.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class RouteDashboardSetup {
    
    /**
    The name to use when creating a new Route
    */
    var newRouteName: String?
    
    /**
     The initial station to seed for a new Route. This is used to zoom the map to the right area to start selecting more stations to add to the route.
     */
    //var station: Station?
    var station: _Station?
    
    /**
    The route to be edited, not used if setting up the RouteDashboard for creation
    */
    var route: _Route?
}

