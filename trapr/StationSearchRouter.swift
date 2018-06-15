//
//  StationSearchRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/06/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StationSearchRouter class
final class StationSearchRouter: Router {
}

// MARK: - StationSearchRouter API
extension StationSearchRouter: StationSearchRouterApi {
}

// MARK: - StationSearch Viper Components
private extension StationSearchRouter {
    var presenter: StationSearchPresenterApi {
        return _presenter as! StationSearchPresenterApi
    }
}
