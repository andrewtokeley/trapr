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
    func showRouteModule(route: Route?)
}

//MARK: - StartView API
protocol StartViewApi: UserInterfaceProtocol {
    func displayRoutes(routes: [Route]?)
    func displayRecentVisits(visits: [VisitSummary]?)
    func askForNewVisitDate(completion: (Date) -> Void)
    func setTitle(title: String, routesSectionTitle: String, routeSectionActionText: String, recentVisitsSectionTitle: String, recentVisitsSectionActionText: String)
}

//MARK: - StartPresenter API
protocol StartPresenterApi: PresenterProtocol {
    
    func didSelectMenu()
    func didSelectNewVisit()
    func didSelectNewRoute()
    func didSelectVisitSummary(visitSummary: VisitSummary)
    func didSelectRoute(route: Route)
    func setRecentVisits(visits: [VisitSummary]?)
    func setRoutes(routes: [Route]?)
}

//MARK: - StartInteractor API
protocol StartInteractorApi: InteractorProtocol {
    func initialiseHomeModule()
}
