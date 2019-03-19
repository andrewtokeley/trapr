//
//  OrderStationsRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 31/01/19.
//Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - OrderStationsRouter class
final class OrderStationsRouter: Router {
}

// MARK: - OrderStationsRouter API
extension OrderStationsRouter: OrderStationsRouterApi {
}

// MARK: - OrderStations Viper Components
private extension OrderStationsRouter {
    var presenter: OrderStationsPresenterApi {
        return _presenter as! OrderStationsPresenterApi
    }
}
