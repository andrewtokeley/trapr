//
//  StartRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StartRouter class
final class StartRouter: Router {
    
    fileprivate lazy var stationService = { ServiceFactory.sharedInstance.stationFirestoreService }()
}

// MARK: - StartRouter API
extension StartRouter: StartRouterApi {
    
    func showMap(route: Route) {
        let module = AppModules.map.build()
        
        let setupData = MapSetupData()
        
        stationService.get { (stations) in
            setupData.stations = stations
            setupData.highlightedStations = setupData.stations.filter({ route.stationIds.contains( $0.locationId ) })
            setupData.showHighlightedOnly = true
            
            module.router.show(from: self.viewController, embedInNavController: true, setupData: setupData)
        }
    }
    
    func showRouteDashboardModule(route: Route?) {
        if let route = route {
            let module = AppModules.routeDashboard.build()
        
            let setupData = RouteDashboardSetup()
        
            //TODO change method to accept _Route
        
            setupData.route = route
            //setupData.delegate = ...
        
            // show modally
            module.router.show(from: viewController, embedInNavController: true, setupData: setupData)
        }
    }
    
    func showRouteModule(route: Route?) {

    }
    
    func showVisitModule(visitSummary: VisitSummary) {
        let module = AppModules.visit.build()
        
        // Remove title from back button
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let setupData = VisitSetup()
        setupData.visitSummary = visitSummary
        module.router.show(from: viewController, embedInNavController: false, setupData: setupData)
    }
    
    func showLoadingScreen(delegate: LoaderDelegate) {
            
        let module = AppModules.loader.build()

        let setup = LoaderPresenterSetupData()
        setup.delegate = delegate

        module.router.showAsModalOverlay(from: viewController, setupData: setup)
        
        
    }
    
    func showSideMenu() {
        let module = AppModules.sideMenu.build()
        
        let setupData = SideMenuSetupData()
        setupData.delegate = self
        module.router.showAsModalOverlay(from: viewController, setupData: setupData)
        
        
    }
    
    func showProfile() {
        let module = AppModules.settings.build()
        
        let setupData = SettingsSetupData()
        setupData.delegate = self.presenter as! StartPresenter
        
        module.router.show(from: viewController, embedInNavController: true, setupData: setupData)
    }
    
    func showMap(setupData: MapSetupData) {
        let module = AppModules.map.build()
        module.router.show(from: viewController, embedInNavController: true, setupData: setupData)
    }
    
    func showNewRouteModule() {
        let module = AppModules.newRoute.build()
        module.router.show(from: viewController, embedInNavController: true, setupData: nil)
    }
    
    func showAdministrationModule() {
        let module = AppModules.administration.build()
        module.router.show(from: viewController, embedInNavController: true, setupData: nil)
    }
}

extension StartRouter: SideMenuDelegate {

    func didSelectMenuItem(menu: SideBarMenuItem, setupData: Any?) {
        
        if menu == .Settings {
            self.showProfile()
        }
        if menu == .Map {
            if let setup = setupData as? MapSetupData {
                self.showMap(setupData: setup)
            }
        }
        if menu == .SignOut {
            if let delegate = presenter as? LoaderDelegate {
                self.showLoadingScreen(delegate: delegate)
            }
        }
        if menu == .Administration {
            self.showAdministrationModule()
        }
    }
}

// MARK: - Start Viper Components
private extension StartRouter {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
}
