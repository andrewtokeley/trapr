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
    func didSelectMenuButton()
    func didSelectInfoButton()
    func didSelectMenuItem(title: String)
    func didSelectDate()
    func setVisitDelegate(delegate: VisitDelegate)
    func visitLogDidScroll(contentOffsetY: CGFloat)
    func didSendEmailSuccessfully()
    func didFetchVisit(visit: Visit)
    func didFindNoVisit()
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
}
