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
        _view.dismiss(animated: true, completion: nil)
    }
}

extension Router {
    func showAsModalOverlay(from: UIViewController, setupData: Any? = nil) {
        if let data = setupData {
            _presenter.setupView(data: data)
        }
        
        _view.modalTransitionStyle = .crossDissolve
        _view.modalPresentationStyle = .overCurrentContext
        from.present(_view, animated: false, completion: nil)
    }
}

// MARK: - DatePicker Viper Components
private extension DatePickerRouter {
    var presenter: DatePickerPresenterApi {
        return _presenter as! DatePickerPresenterApi
    }
}
