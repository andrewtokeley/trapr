//
//  MapModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit
import MapKit

//MARK: - MapRouter API
protocol MapRouterApi: RouterProtocol {
    //func addMapAsChildView(containerView: UIView)
}

//MARK: - MapView API
protocol MapViewApi: UserInterfaceProtocol {
    
    //func getMapContainerView() -> UIView
    //func setVisibleRegionToStation(station: Station, distance: CLLocationDistance)
    //var delegate: StationMapDelegate? { get set }
    //func showUserLocation(_ show: Bool)
    func loadMap()
    func setVisibleRegionToHighlightedStations()
    func setVisibleRegionToAllStations()
    func reapplyStylingToAnnotationViews()
    func showOnlyHighlighted()
    func showAll()
    func displayMenuOptions(options: [OptionItem])
    
    func enableToggleHighlightMode(_ enable: Bool)
    
    
}

//MARK: - MapPresenter API
protocol MapPresenterApi: PresenterProtocol {
    func didFetchStationsToHighlight(stations: [LocatableEntity])
    func didSelectStationOnMap(stationId: String)
    func didSelectClose()
    func didChangeZoomLevel(zoom: Double)
    func didSelectToViewHighlightedOnly()
    func didSelectToViewAll()
    func didSelectMenuButton()
    func didSelectMenuItem(title: String)
}

//MARK: - MapInteractor API
protocol MapInteractorApi: InteractorProtocol {
    func retrieveStationsToHighlight(selectedStationId: String)
}
