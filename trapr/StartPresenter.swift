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
    fileprivate let ROUTE_MENU_MAP = 2
    fileprivate let ROUTE_MENU_DELETE = 3
    
    open override func viewHasLoaded() {
        router.showLoadingScreen()
    }
    
    open override func viewIsAboutToAppear() {
        
            view.setTitle(title: "Trapr", routesSectionTitle: "ROUTES", routeSectionActionText: "NEW", recentVisitsSectionTitle: "VISITS", recentVisitsSectionActionText: "")
            
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
        
        if let route = self.routes?[routeIndex] {
            _view.displayMenuOptions(options: [
                OptionItem(title: "Edit", isEnabled: true, isDestructive: false),
                OptionItem(title: "Visit", isEnabled: true, isDestructive: false),
                OptionItem(title: "Delete", isEnabled: true, isDestructive: true)
                ], actionHandler: {
                    (title) in
                    if title == "Edit" {
                        self.router.showRouteModule(route: route)
                    } else if title == "Visit" {
                        self.didSelectNewVisit(route: route)
                    } else if title == "Delete" {
                        self._view.presentConfirmation(title: "Delete Route", message: "Are you sure you want to delete this route?", response: {
                            (ok) in
                            if ok {
                                self.interactor.deleteRoute(route: route)
                                self.interactor.initialiseHomeModule()
                            }
                        })
                    }
            })
        }
        
//        // for now all routes have the same options
//        routeMenuOptions.removeAll()
//        routeMenuOptions.append("Edit")
//        routeMenuOptions.append("Visit")
//        routeMenuOptions.append("Map")
//        routeMenuOptions.append("Delete")
//        view.setRouteMenu(options: routeMenuOptions)
    }

    func didSelectRouteMenuItem(routeIndex: Int, menuItemIndex: Int) {
        
//        if let route = self.routes?[routeIndex] {
//            if menuItemIndex == ROUTE_MENU_EDIT {
//
//            } else if menuItemIndex == ROUTE_MENU_DELETE {
//
//            } else if menuItemIndex == ROUTE_MENU_VISIT {
//                let visitSummary = VisitSummary(dateOfVisit: Date(), route: route)
//                router.showVisitModule(visitSummary: visitSummary)
//            } else if menuItemIndex == ROUTE_MENU_MAP {
//                router.showMap(route: route)
//            }
//        }
    }
    
    func didSelectMenu() {
        router.showSideMenu()
    }
    
    func didSelectNewVisit(route: Route) {
        let visitSummary = VisitSummary(dateOfVisit: Date(), route: route)
        self.router.showVisitModule(visitSummary: visitSummary)
    }
    
    func didSelectNewRoute() {
        //router.showRouteModule(route: nil)
        //router.showRouteDashboardModule(route: nil)
        router.showNewRouteModule()
    }

    func didSelectEditMenu() {
        
        let options = [
            OptionItem(title: "New Route", isEnabled: true, isDestructive: false)
        ]
        
        _view.displayMenuOptions(options: options, actionHandler: {
            (menuTitle) in
            if menuTitle == options[0].title {
                self.didSelectNewRoute()
            }
        })
    }
    
    func didSelectVisitSummary(visitSummary: VisitSummary) {
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func didSelectLastVisited(route: Route) {
        
        // get the VisitSummary for the latest visit on this route
        if let visit = ServiceFactory.sharedInstance.visitService.getVisits(route: route).sorted(byKeyPath: "visitDateTime", ascending: false).first {
            let visitSummary = VisitSummary(dateOfVisit: visit.visitDateTime, route: route)
            
            router.showVisitModule(visitSummary: visitSummary)
        }
        
    }
    
    func didSelectRoute(route: Route) {
        router.showRouteDashboardModule(route: route)
    }
    
    func setRecentVisits(visits: [VisitSummary]?) {
        view.displayRecentVisits(visits: visits)
    }

    func setRoutes(routes: [Route]?) {
        
        self.routes = routes
        view.displayRoutes(routes: routes)
        
        if routes?.count ?? 0 == 0 {
            view.showNoRoutesLayout(show: true, message: "Before you can record any visits, add the Route you want to visit.")
        } else {
            view.showNoRoutesLayout(show: false, message: nil)
        }
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
