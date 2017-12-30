//
//  MapRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - MapRouter class
final class MapRouter: Router {
}

// MARK: - MapRouter API
extension MapRouter: MapRouterApi {
}

// MARK: - Map Viper Components
private extension MapRouter {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
}
