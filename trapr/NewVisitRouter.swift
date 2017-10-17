//
//  NewVisitRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 7/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewVisitRouter class
final class NewVisitRouter: Router {
}

// MARK: - NewVisitRouter API
extension NewVisitRouter: NewVisitRouterApi {
    
    func showTrapLineSelectModule(delegate: TraplineSelectDelegate?) {
        let module = AppModules.traplineSelect.build()
        
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        module.router.show(from: _view, embedInNavController: false, setupData: delegate)
    }
}

// MARK: - NewVisit Viper Components
private extension NewVisitRouter {
    var presenter: NewVisitPresenterApi {
        return _presenter as! NewVisitPresenterApi
    }
}
