//
//  RouteDashboardModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - RouteDashboardRouter API
protocol RouteDashboardRouterApi: RouterProtocol {
    func addMapAsChildView(containerView: UIView)
}

//MARK: - RouteDashboardView API
protocol RouteDashboardViewApi: UserInterfaceProtocol {
    func displayTitle(_ title: String)
    func displayRouteName(_ name: String?)
    func displayStationsOnMap(stations: [Station], highlightedStations: [Station]?)
    func getMapContainerView() -> UIView
}

//MARK: - RouteDashboardPresenter API
protocol RouteDashboardPresenterApi: PresenterProtocol {
    func didSelectClose()
}

//MARK: - RouteDashboardInteractor API
protocol RouteDashboardInteractorApi: InteractorProtocol {
}
