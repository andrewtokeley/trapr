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
    func setStations(stations: [Station], current: Station)
    func setTraps(traps: [Trap])
    func displayMenuOptions(options: [OptionItem])
    func updateDisplayFor(visit: Visit)
    func updateCurrentStation(index: Int, repeatedGroup: Int)
    func showVisitEmail(visitSummary: VisitSummary, recipient: String?)
    func showConfirmation(title: String, message: String, yes: (() -> Void)?, no: (() -> Void)?)
    func selectTrap(index: Int)
    func confirmDeleteStationMethod()
    var getVisitContainerView: UIView { get }
    
    //func setStationText(text: String)
    //func enableNavigation(previous: Bool, next: Bool)
    
}

//MARK: - VisitPresenter API
protocol VisitPresenterApi: PresenterProtocol {
    func didSelectToAddTrap(trapType: TrapType)
    func didSelectToRemoveTrap(trap: Trap)
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
    
    func deleteOrArchiveTrap(trap: Trap)
    
    /**
     Return all the station's traps which are not archived or are archived but have a visit recorded for them on the specified date
     */
    func getTrapsToDisplay(route: Route, station: Station, date: Date) -> [Trap]
    
    func getUnusedTrapTypes(station: Station) -> [TrapType]
    func updateVisitDates(currentDate: Date, route: Route, newDate: Date)
    func retrieveVisit(date: Date, route: Route, trap: Trap)
    func addVisit(visit: Visit)
    func addOrRestoreTrapToStation(station: Station, trapType: TrapType)
    func deleteVisit(visit: Visit)
    func deleteAllVisits(route: Route, date: Date)
    func addVisitSync(visitSync: VisitSync)
    
    func removeStationFromRoute(route: Route, station: Station)
    func deleteStation(route: Route, station: Station)

    /**
     Insert the station before the given station index
    */
    func insertStation(route: Route, station: Station, at index: Int)
    func addStation(route: Route, station: Station)
}
