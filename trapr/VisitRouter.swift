//
//  VisitRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitRouter class
final class VisitRouter: Router {
    
}

// MARK: - VisitRouter API
extension VisitRouter: VisitRouterApi {
    
    
    func showStationSelectModule(setupData: StationSelectSetupData) {
        let module = AppModules.stationSelect.build()
        module.router.show(from: _view, embedInNavController: true, setupData: setupData)
    }

    func showDatePicker(setupData: DatePickerSetupData) {
        let module = AppModules.datePicker.build()
        module.router.showAsModalOverlay(from: _view, setupData: setupData)
    }
    
}

// MARK: - Visit Viper Components
private extension VisitRouter {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}
