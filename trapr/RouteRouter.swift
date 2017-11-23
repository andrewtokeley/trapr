//
//  RouteRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 21/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - RouteRouter class
final class RouteRouter: Router {
}

// MARK: - RouteRouter API
extension RouteRouter: RouteRouterApi {
    
    func showListPicker(setupData: ListPickerSetupData) {
        let module = AppModules.listPicker.build()
        module.router.show(from: _view, embedInNavController: setupData.embedInNavController, setupData: setupData)
    }
}

// MARK: - Route Viper Components
private extension RouteRouter {
    var presenter: RoutePresenterApi {
        return _presenter as! RoutePresenterApi
    }
}
