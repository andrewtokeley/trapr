//
//  RouteDashboardModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit
import Photos

enum ResizeState {
    case expand
    case collapse
    case hidden
}

//MARK: - RouteDashboardRouter API
protocol RouteDashboardRouterApi: RouterProtocol {
    func showVisitModule(visitSummary: VisitSummary)
    func addMapAsChildView(containerView: UIView)
    func showVisitHistoryModule(route: Route)
}

//MARK: - RouteDashboardView API
protocol RouteDashboardViewApi: class, UserInterfaceProtocol {
    func displayTitle(_ title: String, editable: Bool)
    
    // Editing options
    
    func setTitleOfSelectAllStations(title: String)
    func showEditStationOptions(_ show: Bool)
    func showEditOrderOptions(_ show: Bool)
    func enableSelectAllStationsButton(_ enable: Bool)
    func enableEditDone(_ enable: Bool)
    func enableReverseOrder(_ enable: Bool)
    
    func displayFullScreenMap()
    func displayCollapsedMap()
    
    func displayLastVisitedDate(date: String, allowSelection: Bool)
    func displayStationSummary(summary: String, numberOfStations: Int)
    func displayVisitNumber(number: String, allowSelection: Bool)
    func displayTimes(description: String, allowSelection: Bool)
    
    func setMapResizeIconState(state: ResizeState)
    
    func setVisibleRegionToHighlightedStations()
    func setVisibleRegionToCentreOfStations(distance: Double)
    func setVisibleRegionToStation(station: Station, distance: Double)
    func setVisibleRegionToAllStations()
    
    func enableToggleHighlightMode(_ enable: Bool)
    func getMapContainerView() -> UIView
    
    func reloadMap(forceAnnotationRebuild: Bool)
    func reapplyStylingToAnnotationViews()
    
    func showEditNavigation(_ show: Bool)
    
    func showEditDescription(_ show: Bool, description: String?)
    
    func configureKillChart(catchSummary: StackCount)
    func configurePoisonChart(poisonSummary: StackCount)
}

//MARK: - RouteDashboardPresenter API
protocol RouteDashboardPresenterApi: PresenterProtocol {
    func didSelectClose()
    func didSelectCancel()
    func didSelectEditMenu()
    func didSelectEditStations()
    func didSelectEditOrder()
    func didSelectEditDone()
    func didSelectEditCancel()
    func didUpdateRouteName(name: String?)
    func didSelectVisitHistory()
    func didSelectLastVisited()
    func didSelectTimes()
    //func didSelectResetStations()
    //func didSelectResetOrder()
    func didSelectClearOrder()
    func didSelectReverseOrder()
    func didSelectResize()
    func didSelectHideRoute()
    func didSelectToSelectAllStations()
}

//MARK: - RouteDashboardInteractor API
protocol RouteDashboardInteractorApi: InteractorProtocol {
    func lastVisitedText(route: Route) -> String?
    func lastVisitSummary(route: Route) -> VisitSummary?
    func timeDescription(route: Route) -> String
    func numberOfVisits(route: Route) -> Int
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?)
    func addStationToRoute(route: Route, station: Station) -> Route
    func removeStationFromRoute(route: Route, station: Station) -> Route
    func deleteRoute(route: Route)
    func getRouteName() -> String
    func killCounts(frequency: TimeFrequency, period: TimeFrequency, route: Route) -> StackCount?
    func poisonCounts(frequency: TimeFrequency, period: TimeFrequency, route: Route) -> StackCount?
    func visitsExistForRoute(route: Route) -> Bool
    func getStationSequence(_ from: Station, _ to:Station) -> [Station]?
    
    //func killCounts(monthOffset: Int, route: Route) -> [Species: Int]
}
