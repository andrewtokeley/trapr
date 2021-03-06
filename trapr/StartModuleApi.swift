//
//  StartModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit
import Photos

//MARK: - StartRouter API
protocol StartRouterApi: RouterProtocol {
    func showMap(route: Route)
    func showVisitModule(visitSummary: VisitSummary)
    //func showNewVisitModule(delegate: NewVisitDelegate)
    func showRouteModule(route: Route?)
    func showNewRouteModule()
    func showRouteDashboardModule(route: Route?)
    func showSideMenu()
    func showProfile()
    func showLoadingScreen(delegate: LoaderDelegate)
}

//MARK: - StartView API
protocol StartViewApi: UserInterfaceProtocol {
    func showLoadingScreen()
    func hideLoadingScreen()
    func displayRoutes(routeViewModels: [RouteViewModel]?)
    //func updateImageForRoute(route: Route, imageUrl: Url)
    func displayRecentVisits(visits: [VisitSummary]?)
    func askForNewVisitDate(completion: (Date) -> Void)
    func setRouteMenu(options: [String])
    func setTitle(title: String, routesSectionTitle: String, routeSectionActionText: String, recentVisitsSectionTitle: String, recentVisitsSectionActionText: String)
    func showNoRoutesLayout(show: Bool, message: String?)
}

//MARK: - StartPresenter API
protocol StartPresenterApi: PresenterProtocol {
    func didSelectEditMenu()
    func didSelectLastVisited(routeId: String)
    func didSelectMenu()
    //func didSelectRouteMenu(routeIndex: Int)
    func didSelectRouteMenuItem(routeIndex: Int, menuItemIndex: Int)
    func didSelectNewVisit(routeId: String)
    func didSelectNewRoute()
    func didSelectVisitSummary(visitSummary: VisitSummary)
    func didSelectRoute(route: Route)
    func didSelectRouteImage(route: Route)
    func setRecentVisits(visits: [VisitSummary]?)
    func setRoutes(routes: [Route]?, lastVisitDescriptions: [String])
}

//MARK: - StartInteractor API
protocol StartInteractorApi: InteractorProtocol {
    func initialiseHomeModule()
    func getNewVisitSummary(date: Date, routeId: String, completion: ((VisitSummary?) -> Void)?)
    func getMostRecentVisitSummary(routeId: String, completion: ((VisitSummary?) -> Void)?)
    //func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?)
    func deleteRoute(routeId: String)
    func getLastVisitedDateDescription(routeId: String, completion: ((String) -> Void)?)
    
}
