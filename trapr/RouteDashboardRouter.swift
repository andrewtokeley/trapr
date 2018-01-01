//
//  RouteDashboardRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - RouteDashboardRouter class
final class RouteDashboardRouter: Router {
}

// MARK: - RouteDashboardRouter API
extension RouteDashboardRouter: RouteDashboardRouterApi {
}

// MARK: - RouteDashboard Viper Components
private extension RouteDashboardRouter {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
