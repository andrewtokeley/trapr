//
//  OrderStationsInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 31/01/19.
//Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - OrderStationsInteractor Class
final class OrderStationsInteractor: Interactor {
    
    fileprivate let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    fileprivate let routeService = ServiceFactory.sharedInstance.routeFirestoreService
}

// MARK: - OrderStationsInteractor API
extension OrderStationsInteractor: OrderStationsInteractorApi {
    
    func moveStation(routeId: String, sourceIndex: Int, destinationIndex: Int, completion: (([String]) -> Void)?) {
        
        routeService.moveStationOnRoute(routeId: routeId, sourceIndex: sourceIndex, destinationIndex: destinationIndex) { (route, error) in
            
            if let route = route {
                self.stationService.get(stationIds: route.stationIds) { (stations, error) in
                    completion?(stations.map { $0.longCode })
                }
            }
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension OrderStationsInteractor {
    var presenter: OrderStationsPresenterApi {
        return _presenter as! OrderStationsPresenterApi
    }
}
