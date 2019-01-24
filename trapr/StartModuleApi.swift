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
    func showMap(route: _Route)
    func showVisitModule(visitSummary: _VisitSummary)
    //func showNewVisitModule(delegate: NewVisitDelegate)
    func showRouteModule(route: _Route?)
    func showNewRouteModule()
    func showRouteDashboardModule(route: _Route?)
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
    func displayRecentVisits(visits: [_VisitSummary]?)
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
    func didSelectVisitSummary(visitSummary: _VisitSummary)
    func didSelectRoute(route: _Route)
    func didSelectRouteImage(route: _Route)
    func setRecentVisits(visits: [_VisitSummary]?)
    func setRoutes(routes: [_Route]?, lastVisitDescriptions: [String])
}

//MARK: - StartInteractor API
protocol StartInteractorApi: InteractorProtocol {
    func initialiseHomeModule()
    func getNewVisitSummary(date: Date, routeId: String, completion: ((_VisitSummary?) -> Void)?)
    func getMostRecentVisitSummary(routeId: String, completion: ((_VisitSummary?) -> Void)?)
    //func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?)
    func deleteRoute(routeId: String)
    func getLastVisitedDateDescription(routeId: String, completion: ((String) -> Void)?)
    
}
