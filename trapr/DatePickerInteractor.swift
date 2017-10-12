//
//  DatePickerInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - DatePickerInteractor Class
final class DatePickerInteractor: Interactor {
}

// MARK: - DatePickerInteractor API
extension DatePickerInteractor: DatePickerInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension DatePickerInteractor {
    var presenter: DatePickerPresenterApi {
        return _presenter as! DatePickerPresenterApi
    }
}
