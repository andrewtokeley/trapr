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
    func addMapAsChildView(containerView: UIView)
}

//MARK: - MapView API
protocol MapViewApi: UserInterfaceProtocol {
    func getMapContainerView() -> UIView
    func setVisibleRegionToHighlightedStations()
    func setVisibleRegionToAllStations()
    //func addStationsToMap(stations: [Station], highlightedStations: [Station]?, annotationStyle: AnnotationStyle)
    //func setAnnotationStyle(annotationStyle: AnnotationStyle)
    func showOnlyHighlighted()
    func showAll()
    
    func setTitle(title: String)
    func displayMenuOptions(options: [OptionItem])
    func showUserLocation(_ show: Bool)
    func enableToggleHighlightMode(_ enable: Bool)
    
    var delegate: StationMapDelegate? { get set }
}

//MARK: - MapPresenter API
protocol MapPresenterApi: PresenterProtocol {
    func didSelectClose()
    func didChangeZoomLevel(zoom: Double)
    func didSelectToViewHighlightedOnly()
    func didSelectToViewAll()
    func didSelectMenuButton()
    func didSelectMenuItem(title: String)
}

//MARK: - MapInteractor API
protocol MapInteractorApi: InteractorProtocol {
}
