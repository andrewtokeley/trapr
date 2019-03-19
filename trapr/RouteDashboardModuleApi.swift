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
    func showOrderStationsModule(routeId: String, stations: [Station])
    
    func addMapAsChildView(containerView: UIView)
    func showVisitHistoryModule(visitSummaries: [VisitSummary])
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
    
    func showVisitDetails(show: Bool)
    
    func setMapResizeIconState(state: ResizeState)
    
    func setVisibleRegionToHighlightedStations()
    func setVisibleRegionToCentreOfStations(distance: Double)
    //func setVisibleRegionToStation(station: Station, distance: Double)
    func setVisibleRegionToAllStations()
    
    func enableToggleHighlightMode(_ enable: Bool)
    func getMapContainerView() -> UIView
    
    func reloadMap(forceAnnotationRebuild: Bool)
    func reapplyStylingToAnnotationViews()
    
    func showEditNavigation(_ show: Bool)
    
    func showEditDescription(_ show: Bool, description: String?)
    
    func configureKillChart(catchSummary: StackCount)
    func configurePoisonChart(poisonSummary: StackCount)
    
    func showSpinner()
    func stopSpinner()
}

//MARK: - RouteDashboardPresenter API
protocol RouteDashboardPresenterApi: PresenterProtocol {
    
    // called by interactor
    func didSaveStationEdits()
    func didDeleteRoute()
    func didFetchRouteInformation(information: RouteInformation)
    func didFetchVisitInformation(information: VisitInformation)
    
    // called by view
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

    func currentUser() -> User?
    func saveRoute(route: Route) -> String
    func deleteRoute(routeId: String)
    
    func retrieveStations(completion: (([Station]) -> Void)?)
    func retrieveRouteInformation(route: Route)
    func retrieveVisitInformation(route: Route)
    
    func getStationsDescription(stations: [Station], includeStationCodes: Bool) -> String 
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?)
    func updateStationsOnRoute(routeId: String, stationIds: [String])
    func getStationSequence(fromStationId: String, toStationId: String, completion: (([Station], Error?) -> Void)?)
}
