//
//  NewRouteRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewRouteRouter class
final class NewRouteRouter: Router {
}

// MARK: - NewRouteRouter API
extension NewRouteRouter: NewRouteRouterApi {
    
    func showListPicker(setupData: ListPickerSetupData) {
        let module = AppModules.listPicker.build()
        module.router.show(from: _view, embedInNavController: setupData.embedInNavController, setupData: setupData)
    }
    
    func showRouteDashboard(newRouteName: String, station: _Station) {
        let setupData = RouteDashboardSetup()
        setupData.newRouteName = newRouteName
        setupData.station = station
        let module = AppModules.routeDashboard.build()
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
}

// MARK: - NewRoute Viper Components
private extension NewRouteRouter {
    var presenter: NewRoutePresenterApi {
        return _presenter as! NewRoutePresenterApi
    }
}
