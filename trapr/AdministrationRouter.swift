//
//  AdministrationRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - AdministrationRouter class
final class AdministrationRouter: Router {
}

// MARK: - AdministrationRouter API
extension AdministrationRouter: AdministrationRouterApi {
}

// MARK: - Administration Viper Components
private extension AdministrationRouter {
    var presenter: AdministrationPresenterApi {
        return _presenter as! AdministrationPresenterApi
    }
}
