//
//  VisitHistoryRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 1/02/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitHistoryRouter class
final class VisitHistoryRouter: Router {
}

// MARK: - VisitHistoryRouter API
extension VisitHistoryRouter: VisitHistoryRouterApi {
    
    func showVisitModule(visitSummary: _VisitSummary) {
        let module = AppModules.visit.build()
        
        // Remove title from back button
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let setupData = VisitSetup()
        setupData.visitSummary = visitSummary
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
    
}

// MARK: - VisitHistory Viper Components
private extension VisitHistoryRouter {
    var presenter: VisitHistoryPresenterApi {
        return _presenter as! VisitHistoryPresenterApi
    }
}
