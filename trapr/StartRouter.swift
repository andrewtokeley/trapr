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
    
}

// MARK: - Start Viper Components
private extension StartRouter {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
}
