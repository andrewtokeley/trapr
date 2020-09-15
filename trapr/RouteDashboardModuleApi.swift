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
    
    func showListPicker(setupData: ListPickerSetupData)
    func showVisitModule(visitSummary: VisitSummary)
    func showOrderStationsModule(routeId: String, stations: [Station])
    func showVisitHistoryModule(visitSummaries: [VisitSummary])
}

//MARK: - RouteDashboardView API
protocol RouteDashboardViewApi: UserInterfaceProtocol {
    func displayTitle(_ title: String, editable: Bool)
    
    // MARK: - Map
    func displayStations(stations: [LocatableEntity], stationCounts: [String: Int], legendSegments: [Segment], legendTitle: String)
    func displayMapOptionButtons(buttons: [MapOptionButton], selectedIndex: Int?)
    //func displayHeatmap(title: String, segments: [Segment])
    func reloadMap(forceAnnotationRebuild: Bool)
    func reapplyStylingToAnnotationViews()
    func setVisibleRegionToAllStations()
    
    // MARK: - Stations
    func displayStationSummary(summary: String, numberOfStations: Int)
    func displayTrapsDescription(description: String?)
    
    // MARK: - Visits
    func displayLastVisitedDate(date: String, allowSelection: Bool)
    func displayVisitNumber(number: String, allowSelection: Bool)
    func displayAverageLureSummary(summary: String)
    func showVisitDetails(show: Bool)
    
    // MARK: - Charts
//    func configureKillChartNavigation(navigationStripItems: [NavigationStripItem])
//    func configureBaitChartNavigation(navigationStripItems: [NavigationStripItem])
//    func configureKillChart(counts: StackCount, lastPeriodCounts: StackCount?)
//    func configurePoisonChart(counts: StackCount, lastPeriodCounts: StackCount?)
//
//    func configureKillChart(counts: StackCount, title: String, lastPeriodCounts: StackCount?, lastPeriodTitle: String?)
//    func configurePoisonChart(counts: StackCount, title: String, lastPeriodCounts: StackCount?, lastPeriodTitle: String?)
    
    func displayChart(type: MapType, index: Int)
    func setChartData(type: MapType, counts: [StackCount], titles: [String?])
    
    func showSpinner()
    func stopSpinner()

}

//MARK: - RouteDashboardPresenter API
protocol RouteDashboardPresenterApi: PresenterProtocol {
    
    // Station Map
    func didselectMapOptionButton(optionButton: MapOptionButton)
    func didSelectMapType(mapType: MapType)
    //func getColorForMapStation(station: LocatableEntity, state: AnnotationState) -> UIColor
    func getIsHidden(station: LocatableEntity) -> Bool
    
    // Charts
    func didChangeBaitChartPerion(dataSetIndex: Int)
    func didChangeKillChartPerion(dataSetIndex: Int)
    
    func didSelectClose()
    func didSelectEditMenu()
    func didUpdateRouteName(name: String?)
    
    func didSelectVisitHistory()
    func didSelectLastVisited()
    func didSelectTimes()
    func didSelectTraps()
    
    func didDeleteRoute()
    
}

//MARK: - RouteDashboardInteractor API
protocol RouteDashboardInteractorApi: InteractorProtocol {

    func currentUser() -> User?
    func saveRoute(route: Route) -> String
    func deleteRoute(routeId: String)
    
    func retrieveStations(completion: (([Station]) -> Void)?)
    func retrieveTrapTypes(completion: (([TrapType]) -> Void)?)
    func retrieveRouteInformation(route: Route, completion: ((RouteInformation?, Error?) -> Void)?)
    func retrieveVisitInformation(route: Route, completion: ((VisitInformation?, Error?) -> Void)?)
    
    func retrieveStationKillCounts(route: Route, speciesId: String?, completion: (([String: Int], Error?) -> Void)?)
    func retrieveStationBaitAddedCounts(route: Route, lureId: String, completion: (([String: Int], Error?) -> Void)?)
    
    func getStationsDescription(stations: [Station], includeStationCodes: Bool) -> String 
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?)
    func updateStationsOnRoute(routeId: String, stationIds: [String])
    func getStationSequence(fromStationId: String, toStationId: String, completion: (([Station], Error?) -> Void)?)
}
