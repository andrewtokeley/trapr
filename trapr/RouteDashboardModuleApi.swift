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
    func showVisitModule(route: Route)
}

//MARK: - RouteDashboardView API
protocol RouteDashboardViewApi: UserInterfaceProtocol {
    func displayTitle(_ title: String)
    func displayRouteName(_ name: String?)
    func displayFullScreenMap()
    func displayCollapsedMap()
    func setAlphaEditDoneButton(_ alpha: CGFloat)
    
    func setVisibleRegionToHighlightedStations()
    func setVisibleRegionToCentreOfStations(distance: Double)
    func setVisibleRegionToAllStations()
    
    func enableToggleHighlightMode(_ enable: Bool)
    func getMapContainerView() -> UIView
    
    func reloadMap(forceAnnotationRebuild: Bool)
    func reapplyStylingToAnnotationViews()
    
    func showEditNavigation(_ show: Bool)
    
    func showEditDescription(_ show: Bool, description: String?)
    func showEditStationOptions(_ show: Bool)
    func showEditOrderOptions(_ show: Bool)
}

//MARK: - RouteDashboardPresenter API
protocol RouteDashboardPresenterApi: PresenterProtocol {
    func didSelectClose()
    func didSelectEditMenu()
    func didSelectEditStations()
    func didSelectEditOrder()
    func didSelectEditDone()
    func didSelectEditCancel()
    func didUpdateRouteName(name: String?)
    func didSelectResetStations()
    func didSelectResetOrder()
    func didSelectClearOrder()
    func didSelectReverseOrder()
}

//MARK: - RouteDashboardInteractor API
protocol RouteDashboardInteractorApi: InteractorProtocol {
    func addStationToRoute(route: Route, station: Station) -> Route
    func removeStationFromRoute(route: Route, station: Station) -> Route
    func deleteRoute(route: Route)
}
