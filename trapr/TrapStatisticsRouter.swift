//
//  TrapStatisticsRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/07/20.
//Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TrapStatisticsRouter class
final class TrapStatisticsRouter: Router {
}

// MARK: - TrapStatisticsRouter API
extension TrapStatisticsRouter: TrapStatisticsRouterApi {
}

// MARK: - TrapStatistics Viper Components
private extension TrapStatisticsRouter {
    var presenter: TrapStatisticsPresenterApi {
        return _presenter as! TrapStatisticsPresenterApi
    }
}
