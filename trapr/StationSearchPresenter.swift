//
//  StationSearchPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/06/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import CoreLocation

// MARK: - StationSearchPresenter Class
final class StationSearchPresenter: Presenter {
    
    fileprivate var delegate: StationSearchDelegate?
    fileprivate var region: Region?
    
    override func setupView(data: Any) {
        if let setupData = data as? StationSearchSetupData {
            self.delegate = setupData.delegate
            self.region = setupData.region
        }
    }
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        interactor.fetchStations(searchTerm: "", regionId: self.region!.id!)
        
        self.getNearbyStations()
        view.setTitle(title: "Stations")
    }
    
    func getNearbyStations() {
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        interactor.fetchNearbyStations(currentLocation: location)
    }
}

// MARK: - StationSearchPresenter API
extension StationSearchPresenter: StationSearchPresenterApi {
    
    func didSelectStation(station: Station) {
        delegate?.stationSearch(view as! StationSearchView, didSelectStation: station)
        (_view as! UserInterface).navigationController?.popViewController(animated: true)
    }
    
    func didEnterSearchTerm(searchTerm: String) {
        
        // clear the nearby stations, during search
        if searchTerm != "" {
            view.showNearbyStations(stations: [Station](), distances: [String]())
        } else {
            self.getNearbyStations()
        }
        
        interactor.fetchStations(searchTerm: searchTerm, regionId: self.region!.id!)
    }
    
    func didFetchNearbyStations(stations: [Station], distances: [String]) {
        view.showNearbyStations(stations: stations, distances: distances)
    }
    
    func didFetchStations(stations: [Station], fromSearch: Bool) {
        if fromSearch {
            view.showSearchResults(stations: stations)
        } else {
            view.showOtherStations(stations: stations)
        }
    }
    
    func didSelectCancel() {
        
    }
    
    func didSelectAdd() {
        
    }
    
}

// MARK: - StationSearch Viper Components
private extension StationSearchPresenter {
    var view: StationSearchViewApi {
        return _view as! StationSearchViewApi
    }
    var interactor: StationSearchInteractorApi {
        return _interactor as! StationSearchInteractorApi
    }
    var router: StationSearchRouterApi {
        return _router as! StationSearchRouterApi
    }
}
