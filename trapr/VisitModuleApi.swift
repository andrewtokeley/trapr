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
    func showDatePicker(setupData: DatePickerSetupData)
    func addVisitLogToView()
}

//MARK: - VisitView API
protocol VisitViewApi: UserInterfaceProtocol {
    func setTitle(title: String, subTitle: String)
    func setStations(stations: [Station], current: Station)
    func setTraps(traps: [Trap])
    func displayMenuOptions(options: [String])
    func updateDisplayFor(visit: Visit)
    func updateCurrentStation(index: Int, repeatedGroup: Int)
    
    var getVisitContainerView: UIView { get }
    
    //func setStationText(text: String)
    //func enableNavigation(previous: Bool, next: Bool)
    
}

//MARK: - VisitPresenter API
protocol VisitPresenterApi: PresenterProtocol {
    
    func didSelectTrap(index: Int)
    func didSelectStation(index: Int)
    func didFetchVisit(visit: Visit)
    func didSelectMenuButton()
    func didSelectMenuItem(title: String)
    func didSelectDate()
    func setVisitDelegate(delegate: VisitDelegate)
    
}

//MARK: - VisitInteractor API
protocol VisitInteractorApi: InteractorProtocol {
    func retrieveVisit(trap: Trap, date: Date)
    func addVisit(visit: Visit)
}
