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
    func showVisitHistoryModule(visitSummaries: [VisitSummary])
}

//MARK: - RouteDashboardView API
protocol RouteDashboardViewApi: UserInterfaceProtocol {
    func displayTitle(_ title: String, editable: Bool)
    
    // MARK: - Map
    func displayStations(stations: [LocatableEntity])
    func displayHeatmap(title: String, segments: [Segment])
    func reloadMap(forceAnnotationRebuild: Bool)
    func reapplyStylingToAnnotationViews()
    func setVisibleRegionToAllStations()
    
    // MARK: - Visits
    func displayLastVisitedDate(date: String, allowSelection: Bool)
    func displayStationSummary(summary: String, numberOfStations: Int)
    func displayVisitNumber(number: String, allowSelection: Bool)
    func displayTimes(description: String, allowSelection: Bool)
    func showVisitDetails(show: Bool)
    
    // MARK: - Charts
    func configureKillChart(catchSummary: StackCount)
    func configurePoisonChart(poisonSummary: StackCount)
    
    func showSpinner()
    func stopSpinner()

}

//MARK: - RouteDashboardPresenter API
protocol RouteDashboardPresenterApi: PresenterProtocol {
    
    // called by interactor
    //func didSaveStationEdits()
    func didDeleteRoute()
    //func didFetchRouteInformation(information: RouteInformation)
    //func didFetchVisitInformation(information: VisitInformation)
    //func didFetchStationKillCounts(counts: [String: Int])
    
    // called by view
    func getColorForMapStation(station: LocatableEntity, state: AnnotationState) -> UIColor
    //func getHeatMapSegments() -> [Segment]
    func getIsHidden(station: LocatableEntity) -> Bool
    func didselectMapFilterOption(option: MapOption)
    
    func didSelectClose()
    //func didSelectCancel()
    func didSelectEditMenu()
   // func didSelectEditStations()
    //func didSelectEditOrder()
    //func didSelectEditDone()
    //func didSelectEditCancel()
    func didUpdateRouteName(name: String?)
    
    func didSelectMapOptionAllTrapTypes()
    func didSelectMapOptionPossumMaster()
    func didSelectMapOptionTimms()
    func didSelectMapOptionDoc200()
    
    func didSelectVisitHistory()
    func didSelectLastVisited()
    func didSelectTimes()
    //func didSelectResetStations()
    //func didSelectResetOrder()
    //func didSelectClearOrder()
    //func didSelectReverseOrder()
    //func didSelectResize()
    //func didSelectHideRoute()
    //func didSelectToSelectAllStations()
}

//MARK: - RouteDashboardInteractor API
protocol RouteDashboardInteractorApi: InteractorProtocol {

    func currentUser() -> User?
    func saveRoute(route: Route) -> String
    func deleteRoute(routeId: String)
    
    func retrieveStations(completion: (([Station]) -> Void)?)
    func retrieveRouteInformation(route: Route, completion: ((RouteInformation?, Error?) -> Void)?)
    func retrieveVisitInformation(route: Route, completion: ((VisitInformation?, Error?) -> Void)?)
    
    func retrieveStationKillCounts(route: Route, trapTypeId: String?, completion: (([String: Int], Error?) -> Void)?)
    
    func getStationsDescription(stations: [Station], includeStationCodes: Bool) -> String 
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?)
    func updateStationsOnRoute(routeId: String, stationIds: [String])
    func getStationSequence(fromStationId: String, toStationId: String, completion: (([Station], Error?) -> Void)?)
}
