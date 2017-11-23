//
//  VisitLogRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitLogRouter class
final class VisitLogRouter: Router {
}

// MARK: - VisitLogRouter API
extension VisitLogRouter: VisitLogRouterApi {
    
    func showDatePicker(setupData: DatePickerSetupData) {
        let module = AppModules.datePicker.build()
        module.router.showAsModalOverlay(from: _view, setupData: setupData)
    }
    
    func showListPicker(setupData: ListPickerSetupData) {
        let module = AppModules.listPicker.build()
        module.router.show(from: _view, embedInNavController: setupData.embedInNavController, setupData: setupData)
    }
    
}

// MARK: - VisitLog Viper Components
private extension VisitLogRouter {
    var presenter: VisitLogPresenterApi {
        return _presenter as! VisitLogPresenterApi
    }
}
