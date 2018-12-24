//
//  StationSearchInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/06/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import CoreLocation

// MARK: - StationSearchInteractor Class
final class StationSearchInteractor: Interactor {
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
}

// MARK: - StationSearchInteractor API
extension StationSearchInteractor: StationSearchInteractorApi {
    
    func fetchNearbyStations(currentLocation: CLLocationCoordinate2D) {
        
        stationService.get { (stations) in
            
            // TODO: WTF?
            // fake it
            let nearbyStations = [stations[0], stations[1], stations[3]]
            let distances = ["100m", "233m", "240m"]
            self.presenter.didFetchNearbyStations(stations: nearbyStations, distances: distances)
        }
        
    }
    
    func fetchStations(searchTerm: String, regionId: String) {
        if searchTerm != "" {
            stationService.searchStations(searchTerm: searchTerm, regionId: regionId) { (stations) in
                self.presenter.didFetchStations(stations: stations, fromSearch: true)
            }
        } else {
            stationService.get(regionId: regionId) { (stations) in
                self.presenter.didFetchStations(stations: stations, fromSearch: false)
            }
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension StationSearchInteractor {
    var presenter: StationSearchPresenterApi {
        return _presenter as! StationSearchPresenterApi
    }
}
