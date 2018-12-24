//
//  NewRouteInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewRouteInteractor Class
final class NewRouteInteractor: Interactor {
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
}

// MARK: - NewRouteInteractor API
extension NewRouteInteractor: NewRouteInteractorApi {
    
    func retrieveTraplines(regionId: String) {
        traplineService.get(regionId: regionId) { (traplines) in
            self.presenter.didFetchTraplines(traplines: traplines)
        }
    }
    
    func retrieveStations(traplineId: String) {
        stationService.get(traplineId: traplineId) { (stations) in
            self.presenter.didFetchStations(stations: stations)
        }
    }
    
    func retrieveRegions() {
        regionService.get { (regions, error) in
            self.presenter.didFetchRegions(regions: regions)
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension NewRouteInteractor {
    var presenter: NewRoutePresenterApi {
        return _presenter as! NewRoutePresenterApi
    }
}
