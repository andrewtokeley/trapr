//
//  RouteServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol RouteServiceInterface {
    
    /**
     Record a new Route
     
     - parameters:
     - route: the Route to add to the repository
     */
    func add(route: Route)

    func getAll() -> Results<Route>
}
