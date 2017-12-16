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
}

// MARK: - StartRouter API
extension StartRouter: StartRouterApi {
    
    func showRouteModule(route: Route?) {
        let module = AppModules.route.build()
        
        let setupData = RouteSetupData()
        setupData.route = route
        //setupData.delegate = ...
        
        // show modally
        module.router.show(from: _view, embedInNavController: true, setupData: setupData)
    }
    
    func showVisitModule(visitSummary: VisitSummary) {
        let module = AppModules.visit.build()
        
        // Remove title from back button
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        module.router.show(from: _view, embedInNavController: false, setupData: visitSummary)
    }
    
    func showNewVisitModule(delegate: NewVisitDelegate) {
        let module = AppModules.newVisit.build()
        module.router.show(from: _view, embedInNavController: true, setupData: delegate)
    }
    
    func showSideMenu() {
        let module = AppModules.sideMenu.build()
        
        let setupData = SideMenuSetupData()
        setupData.delegate = self
        module.router.showAsModalOverlay(from: _view, setupData: setupData)
        
        
    }
    
    func showProfile() {
        let module = AppModules.profile.build()
        module.router.show(from: _view, embedInNavController: true, setupData: nil)
    }
}

extension StartRouter: SideMenuDelegate {

    func didSelectMenuItem(menu: SideBarMenuItem) {
        if menu == .Settings {
            self.showProfile()
        }
    }
}

// MARK: - Start Viper Components
private extension StartRouter {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
}
