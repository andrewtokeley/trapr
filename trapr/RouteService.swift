//
//  RouteService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class RouteService: Service, RouteServiceInterface {
    
    func add(route: Route) {
        try! realm.write {
            realm.add(route)
        }
    }
    
    func getAll() -> Results<Route> {
        return realm.objects(Route.self)
    }
    
    func delete(route: Route) {
        try! realm.write {
            realm.delete(route)
        }
    }
    
    func routeExists(route: Route) -> Bool {
        
        // get all the routes
        let routes = getAll()
        
        return routes.contains(where: {
            $0.longDescription == route.longDescription
        })
    }
    
}
