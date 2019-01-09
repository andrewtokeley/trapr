//
//  StartPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import Photos

// MARK: - StartPresenter Class
final class StartPresenter: Presenter {
    
    fileprivate var showLoader: Bool = true
    
    fileprivate var routeMenuOptions = [String]()
    fileprivate var routes: [_Route]?
    fileprivate var routeViewModels = [RouteViewModel]()
    
    fileprivate let ROUTE_MENU_EDIT = 0
    fileprivate let ROUTE_MENU_VISIT = 1
    fileprivate let ROUTE_MENU_MAP = 2
    fileprivate let ROUTE_MENU_DELETE = 3
    
    override func setupView(data: Any) {
//        if let setup = data as? StartSetupData {
//            //showLoader = setup.showLoader
//        }
    }
    
    override func viewHasLoaded() {
        view.setTitle(title: "Routes", routesSectionTitle: "ROUTES", routeSectionActionText: "NEW", recentVisitsSectionTitle: "VISITS", recentVisitsSectionActionText: "")
    }
    
    override func viewIsAboutToAppear() {
//        if self.showLoader {
//            router.showLoadingScreen(delegate: self)
//            self.showLoader = false
//        } else {
            interactor.initialiseHomeModule()
//        }
    }
}

// MARK: - LoaderDelegate
extension StartPresenter: LoaderDelegate {
    
    func loaderAboutToClose() {
        // set up the view
        interactor.initialiseHomeModule()
    }
}

// MARK: - StartPresenter API
extension StartPresenter: StartPresenterApi {
    
//    func didSelectRouteMenu(routeIndex: Int) {
//        
//        if let route = self.routes?[routeIndex] {
//            _view.displayMenuOptions(options: [
//                OptionItem(title: "Edit", isEnabled: true, isDestructive: false),
//                OptionItem(title: "Visit", isEnabled: true, isDestructive: false),
//                OptionItem(title: "Delete", isEnabled: true, isDestructive: true)
//                ], actionHandler: {
//                    (title) in
//                    if title == "Edit" {
//                        self.router.showRouteModule(route: route)
//                    } else if title == "Visit" {
//                        self.didSelectNewVisit(route: route)
//                    } else if title == "Delete" {
//                        self._view.presentConfirmation(title: "Delete Route", message: "Are you sure you want to delete this route?", response: {
//                            (ok) in
//                            if ok {
//                                self.interactor.deleteRoute(route: route)
//                                self.interactor.initialiseHomeModule()
//                            }
//                        })
//                    }
//            })
//        }
//    }

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
    
    func didSelectNewVisit(routeId: String) {
        interactor.getNewVisitSummary(date: Date(), routeId: routeId) { (visitSummary) in
            if let visitSummary = visitSummary {
                self.router.showVisitModule(visitSummary: visitSummary)
            }
        }
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
    
    func didSelectVisitSummary(visitSummary: _VisitSummary) {
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func didSelectLastVisited(routeId: String) {
        
        // get the VisitSummary for the latest visit on this route
        interactor.getMostRecentVisitSummary(routeId: routeId) { (visitSummary) in
            if let visitSummary = visitSummary {
                self.router.showVisitModule(visitSummary: visitSummary)
            }
        }
    }
    
    func didSelectRoute(route: _Route) {
        router.showRouteDashboardModule(route: route)
    }
    
    func didSelectRouteImage(route: _Route) {
        
        router.showRouteDashboardModule(route: route)
        
//        // get permission to access photos
//        let status = PHPhotoLibrary.authorizationStatus()
//
//        var authorized = status == PHAuthorizationStatus.authorized
//
//        if !authorized  {
//            PHPhotoLibrary.requestAuthorization({status in
//                authorized = status == PHAuthorizationStatus.authorized
//            })
//        }
//
//        if authorized {
//            CameraHandler.shared.showActionSheet(vc: _view)
//            CameraHandler.shared.imagePickedBlock = { (asset) in
//
//                // save the url against the route
//                self.interactor.setRouteImage(route: route, asset: asset, completion: {
//
//                    // refresh page
//                    self.interactor.initialiseHomeModule()
//                })
//
//            }
//        }
    }
    
    func setRecentVisits(visits: [_VisitSummary]?) {
        view.displayRecentVisits(visits: visits)
    }

    func setRoutes(routes: [_Route]?, lastVisitDescriptions: [String]) {
        
        self.routes = routes
        
        // create an array of RouteViewModel instances
        self.routeViewModels = [RouteViewModel]()
        if let routes  = routes {
            var i = 0
            for route in routes {
                let routeViewModel = RouteViewModel(route: route)
                routeViewModel.visitSync = false
                
                routeViewModel.lastVisitedText = lastVisitDescriptions[i]
                i += 1
                routeViewModels.append(routeViewModel)
            }
        }
        view.displayRoutes(routeViewModels: self.routeViewModels)
        
        if routes?.count ?? 0 == 0 {
            view.showNoRoutesLayout(show: true, message: "Before you get going, create a route to visit.")
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
