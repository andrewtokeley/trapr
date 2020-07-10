//
//  VisitModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - VisitRouter API
protocol VisitRouterApi: RouterProtocol {
    func showStationSelectModule(setupData: StationSelectSetupData)
    func showEditRoute(setupData: TraplineSelectSetupData)
    func showListPicker(setupData: ListPickerSetupData)
    func showDatePicker(setupData: DatePickerSetupData)
    func addVisitLogToView()
    func showMap(stations: [Station], highlightedStations: [Station]?)
    func showAddStation(setupData: StationSearchSetupData) 
}

//MARK: - VisitView API
protocol VisitViewApi: UserInterfaceProtocol {
    func setTitle(title: String, subTitle: String)
    func setStations(stations: [Station], current: Station, repeatCount: Int)
    func setTraps(trapTypes: [TrapType])
    func displayMenuOptions(options: [OptionItem])
    func updateDisplayFor(visit: Visit)
    func updateCurrentStation(index: Int, repeatedGroup: Int)
    
    //func showVisitEmail(subject: String, html: String, recipient: String)
    func showVisitEmail(subject: String, message: String, attachmentFilename: String, attachmentData: Data, attachmentMimeType: String, recipient: String)
    
    func showConfirmation(title: String, message: String, yes: (() -> Void)?, no: (() -> Void)?)
    func selectTrap(index: Int)
    func confirmDeleteStationMethod()
    var getVisitContainerView: UIView { get }
    
    //func setStationText(text: String)
    //func enableNavigation(previous: Bool, next: Bool)
    
}

//MARK: - VisitPresenter API
protocol VisitPresenterApi: PresenterProtocol {
    
    func didFetchInitialState(trapTypes: [TrapType])
    func didSelectToAddTrap(trapType: TrapType)
    func didSelectToRemoveTrap(trapType: TrapType)
    func didSelectTrap(index: Int)
    func didSelectStation(index: Int, trapIndex: Int)
    func didSelectAddStation()
    func didSelectMenuButton()
    func didSelectInfoButton()
    func didSelectMenuItem(title: String)
    func didSelectDate()
    func setVisitDelegate(delegate: VisitDelegate)
    func visitLogDidScroll(contentOffsetY: CGFloat)
    func didSendEmailSuccessfully()
    func didFetchVisit(visit: Visit)
    //func didAddStation(station: Station)
    func didFindNoVisit()
    func didUpdateRoute2(route: Route, selectedIndex: Int)
    func didSelectRemoveStation()
    func didSelectDeleteStation()
}

//MARK: - VisitInteractor API
protocol VisitInteractorApi: InteractorProtocol {
    
    func retrieveInitialState()
    
    func generateVisitReportFile(date: Date, route: Route, completion: ((Data?, String?, String?, Error?) -> Void)?)
    func getRecipientForVisitReport(completion: ((String?) -> Void)?)
    
    //func retrieveHtmlForVisit(date: Date, route: Route, completion: ((String, String) -> Void)?)
    
    func deleteOrArchiveTrap(station: Station, trapTypeId: String)
    func numberOfVisits(routeId: String, date: Date, completion: ((Int) -> Void)?)
    func getUnusedTrapTypes(allTrapTypes: [TrapType], station: Station) -> [TrapType]
    
    /**
     Return all the station's traps which are not archived or are archived but have a visit recorded for them on the specified date
     */
    func retrieveTrapsToDisplay(route: Route, station: Station, date: Date, completion: (([TrapType]) -> Void)?)
    
    func updateVisitDates(currentDate: Date, routeId: String, newDate: Date)
    func retrieveVisit(date: Date, routeId: String, stationId: String, trapTypeId: String)
    func addVisit(date: Date, routeId: String, traplineId: String, stationId: String, trapTypeId: String)
    func addOrRestoreTrapToStation(station: Station, trapTypeId: String)

    func deleteVisit(visit: Visit)
    
    func deleteAllVisits(routeId: String, date: Date)
    //func addVisitSync(visitSync: VisitSync)
    
    func removeStationFromRoute(route: Route, stationId: String)
    func deleteStation(route: Route, stationId: String)

    /**
     Insert the station before the given station index
    */
    func insertStation(routeId: String, stationId: String, at index: Int)
    func addStation(route: Route, station: Station)
}
