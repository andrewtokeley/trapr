//
//  StationSearchModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/06/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit
import CoreLocation

//MARK: - StationSearchRouter API
protocol StationSearchRouterApi: RouterProtocol {
}

//MARK: - StationSearchView API
protocol StationSearchViewApi: UserInterfaceProtocol {
    func showNearbyStations(stations: [_Station], distances: [String])
    func showOtherStations(stations: [_Station])
    func showSearchResults(stations: [_Station])
}

//MARK: - StationSearchPresenter API
protocol StationSearchPresenterApi: PresenterProtocol {
    func didSelectStation(station: _Station)
    func didEnterSearchTerm(searchTerm: String)
    func didFetchNearbyStations(stations: [_Station], distances: [String])
    func didFetchStations(stations: [_Station], fromSearch: Bool)
    func didSelectCancel()
    func didSelectAdd()
}

//MARK: - StationSearchInteractor API
protocol StationSearchInteractorApi: InteractorProtocol {
    func fetchNearbyStations(currentLocation: CLLocationCoordinate2D)
    func fetchStations(searchTerm: String, regionId: String)
}
