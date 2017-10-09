//
//  StartModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - StartRouter API
protocol StartRouterApi: RouterProtocol {
    func showVisitModule(visitSummary: VisitSummary)
    func showNewVisitModule(delegate: NewVisitDelegate)
}

//MARK: - StartView API
protocol StartViewApi: UserInterfaceProtocol {
    func displayRecentVisits(visits: [VisitSummary]?)
    func askForNewVisitDate(completion: (Date) -> Void)
    func setTitle(title: String)
}

//MARK: - StartPresenter API
protocol StartPresenterApi: PresenterProtocol {
    
    func didSelectMenu()
    func didSelectNewVisit()
    func didSelectVisitSummary(visitSummary: VisitSummary)
    
    func setRecentVisits(visits: [VisitSummary]?)
}

//MARK: - StartInteractor API
protocol StartInteractorApi: InteractorProtocol {
    func initialiseHomeModule()
}
