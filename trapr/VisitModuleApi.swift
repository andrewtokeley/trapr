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
    func showDatePicker(setupData: DatePickerSetupData)
}

//MARK: - VisitView API
protocol VisitViewApi: UserInterfaceProtocol {
    func setTitle(title: String)
    func setStationText(text: String)
    func setTraps(traps: [Trap])
    func showDatePicker(date: Date)
    func enableNavigation(previous: Bool, next: Bool)
    func displayMenuOptions(options: [String])
}

//MARK: - VisitPresenter API
protocol VisitPresenterApi: PresenterProtocol {
    
    func didSelectPreviousStation()
    func didSelectNextStation()
    func didSelectTrap(index: Int)
    func didSelectStation()
    func didFetchVisit(visit: Visit?)
    func didSelectMenuButton()
    func didSelectDate()
}

//MARK: - VisitInteractor API
protocol VisitInteractorApi: InteractorProtocol {
    func retrieveVisit(trap: Trap, date: Date)
    func addVisit(visit: Visit)
}
