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
    
    func showVisitModule(visitSummary: VisitSummary) {
        let module = AppModules.visit.build()
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
