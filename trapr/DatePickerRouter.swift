//
//  DatePickerRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - DatePickerRouter class
final class DatePickerRouter: Router {
    
}

// MARK: - DatePickerRouter API
extension DatePickerRouter: DatePickerRouterApi {
    
    func closeModule() {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - DatePicker Viper Components
private extension DatePickerRouter {
    var presenter: DatePickerPresenterApi {
        return _presenter as! DatePickerPresenterApi
    }
}
