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
    func showNearbyStations(stations: [Station], distances: [String])
    func showOtherStations(stations: [Station])
    func showSearchResults(stations: [Station])
}

//MARK: - StationSearchPresenter API
protocol StationSearchPresenterApi: PresenterProtocol {
    func didSelectStation(station: Station)
    func didEnterSearchTerm(searchTerm: String)
    func didFetchNearbyStations(stations: [Station], distances: [String])
    func didFetchStations(stations: [Station], fromSearch: Bool)
    func didSelectCancel()
    func didSelectAdd()
}

//MARK: - StationSearchInteractor API
protocol StationSearchInteractorApi: InteractorProtocol {
    func fetchNearbyStations(currentLocation: CLLocationCoordinate2D)
    func fetchStations(searchTerm: String, regionId: String)
}
