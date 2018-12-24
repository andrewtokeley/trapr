//
//  MapInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - MapInteractor Class
final class MapInteractor: Interactor {
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
}

// MARK: - MapInteractor API
extension MapInteractor: MapInteractorApi {
    
    func retrieveStationsToHighlight(selectedStationId: String) {
        
        stationService.get(stationId: selectedStationId) { (station, error) in
            if let traplineId = station?.traplineId {
                self.stationService.get(traplineId: traplineId, completion: { (stations) in
                    self.presenter.didFetchStationsToHighlight(stations: stations)
                })
            }
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension MapInteractor {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
}
