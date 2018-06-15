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
}

// MARK: - StationSearchInteractor API
extension StationSearchInteractor: StationSearchInteractorApi {
    
    func fetchNearbyStations(currentLocation: CLLocationCoordinate2D) {
        
        let stations = ServiceFactory.sharedInstance.stationService.getAll()
        
        // fake it
        let nearbyStations = [stations[0], stations[1], stations[3]]
        let distances = ["100m", "233m", "240m"]
        presenter.didFetchNearbyStations(stations: nearbyStations, distances: distances)
    }
    
    func fetchStations(searchTerm: String, region: Region?) {
        var stations: [Station]
        var isSearchResult = false
        if searchTerm != "" {
            stations = ServiceFactory.sharedInstance.stationService.searchStations(searchTerm: searchTerm, region: region)
            isSearchResult = true
        } else {
            stations = ServiceFactory.sharedInstance.stationService.getAll(region: region)
        }
        
        presenter.didFetchStations(stations: stations, fromSearch: isSearchResult)
    }
    
}

// MARK: - Interactor Viper Components Api
private extension StationSearchInteractor {
    var presenter: StationSearchPresenterApi {
        return _presenter as! StationSearchPresenterApi
    }
}
