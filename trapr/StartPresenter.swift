//
//  StartPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StartPresenter Class
final class StartPresenter: Presenter {
    
    fileprivate var routeMenuOptions = [String]()
    fileprivate var routes: [Route]?
    
    fileprivate let ROUTE_MENU_EDIT = 0
    fileprivate let ROUTE_MENU_VISIT = 1
    fileprivate let ROUTE_MENU_DELETE = 2
    
    open override func viewIsAboutToAppear() {
        view.setTitle(title: "Trapr", routesSectionTitle: "ROUTES", routeSectionActionText: "NEW", recentVisitsSectionTitle: "RECENT", recentVisitsSectionActionText: "ALL")
        
        interactor.initialiseHomeModule()
    }
}

// MARK: - NewVisitDelegate
//extension StartPresenter: NewVisitDelegate {
//    func didSelectRoute(route: Route) {
//
//        let visitSummary = VisitSummary(dateOfVisit: Date(), route: route)
//        router.showVisitModule(visitSummary: visitSummary)
//
//    }
//}

// MARK: - StartPresenter API
extension StartPresenter: StartPresenterApi {
    
    func didSelectRouteMenu(routeIndex: Int) {
        // for now all routes have the same options
        routeMenuOptions.removeAll()
        routeMenuOptions.append("Edit Route")
        routeMenuOptions.append("Visit Route")
        routeMenuOptions.append("Delete Route")
        view.setRouteMenu(options: routeMenuOptions)
    }

    func didSelectRouteMenuItem(routeIndex: Int, menuItemIndex: Int) {
        
        if let route = self.routes?[routeIndex] {
            if menuItemIndex == ROUTE_MENU_EDIT {
                router.showRouteModule(route: route)
            } else if menuItemIndex == ROUTE_MENU_DELETE {
                interactor.deleteRoute(route: route)
                interactor.initialiseHomeModule()
            } else if menuItemIndex == ROUTE_MENU_VISIT {
                self.didSelectRoute(route: route)
            }
        }
    }
    
    func didSelectMenu() {
        let module = AppModules.sideMenu.build()
        module.router.showAsModalOverlay(from: _view)
    }
    
    func didSelectNewVisit() {
        //router.showNewVisitModule(delegate: self)
    }
    
    func didSelectNewRoute() {
        router.showRouteModule(route: nil)
    }
    
    func didSelectVisitSummary(visitSummary: VisitSummary) {
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func didSelectRoute(route: Route) {
        let visitSummary = VisitSummary(dateOfVisit: Date(), route: route)
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func setRecentVisits(visits: [VisitSummary]?) {
        view.displayRecentVisits(visits: visits)
    }

    func setRoutes(routes: [Route]?) {
        self.routes = routes
        view.displayRoutes(routes: routes)
    }
    
}

// MARK: - Start Viper Components
private extension StartPresenter {
    var view: StartViewApi {
        return _view as! StartViewApi
    }
    var interactor: StartInteractorApi {
        return _interactor as! StartInteractorApi
    }
    var router: StartRouterApi {
        return _router as! StartRouterApi
    }
}
