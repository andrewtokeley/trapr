//
//  TraplineSelectInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectInteractor Class
final class TraplineSelectInteractor: Interactor {
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
}

// MARK: - TraplineSelectInteractor API
extension TraplineSelectInteractor: TraplineSelectInteractorApi {
    
    func getAllTraplines(completion: (([Trapline]) -> Void)?) {
        traplineService.get { (traplines) in
            completion?(traplines)
        }
    }
    
    func addRoute(route: Route) {
        routeService.add(route: route, completion: nil)
    }
    
    func updateStations(routeId: String, stationIds: [String]) {
        routeService.updateStations(routeId: routeId, stationIds: stationIds, completion: nil)
    }
    
}

// MARK: - Interactor Viper Components Api
private extension TraplineSelectInteractor {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
}
