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
}

//MARK: - MapView API
protocol MapViewApi: UserInterfaceProtocol {
    func setVisibleRegionToHighlightedStations()
    func setVisibleRegionToAllStations()
    func addStationsToMap(stations: [Station], highlightedStations: [Station]?, annotationStyle: AnnotationStyle)
    func setAnnotationStyle(annotationStyle: AnnotationStyle)
    func showOnlyHighlighted()
    func showAll()
    func setTitle(title: String)
    func displayMenuOptions(options: [OptionItem])
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
