//
//  StationSelectRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StationSelectRouter class
final class StationSelectRouter: Router {
}

// MARK: - StationSelectRouter API
extension StationSelectRouter: StationSelectRouterApi {
    func showTraplineSelectModule(setupData: TraplineSelectDelegate) {
        let module = AppModules.traplineSelect.build()
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
}

// MARK: - StationSelect Viper Components
private extension StationSelectRouter {
    var presenter: StationSelectPresenterApi {
        return _presenter as! StationSelectPresenterApi
    }
}
