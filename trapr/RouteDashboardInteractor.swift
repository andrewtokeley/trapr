//
//  RouteDashboardInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - RouteDashboardInteractor Class
final class RouteDashboardInteractor: Interactor {
    
}

// MARK: - RouteDashboardInteractor API
extension RouteDashboardInteractor: RouteDashboardInteractorApi {
    
    func deleteRoute(route: Route)
    {
        // sometimes we're given a copy of the route, best to get from realm first.
        if let routeToDelete = ServiceFactory.sharedInstance.routeService.getById(id: route.id) {
            ServiceFactory.sharedInstance.routeService.delete(route: routeToDelete)
        }
    }
    
    func addStationToRoute(route: Route, station: Station) -> Route {
        let service = ServiceFactory.sharedInstance.routeService
        service.addStationToRoute(route: route, station: station)
        return service.getById(id: route.id)!
    }
    
    func removeStationFromRoute(route: Route, station: Station) -> Route {
        let service = ServiceFactory.sharedInstance.routeService
        service.removeStationFromRoute(route: route, station: station)
        return service.getById(id: route.id)!
    }
    
}

// MARK: - Interactor Viper Components Api
private extension RouteDashboardInteractor {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
