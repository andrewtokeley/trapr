//
//  TraplineSelectRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectRouter class
final class TraplineSelectRouter: Router {
}

// MARK: - TraplineSelectRouter API
extension TraplineSelectRouter: TraplineSelectRouterApi {
}

// MARK: - TraplineSelect Viper Components
private extension TraplineSelectRouter {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
}
