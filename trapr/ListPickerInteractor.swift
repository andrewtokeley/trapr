//
//  ListPickerInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ListPickerInteractor Class
final class ListPickerInteractor: Interactor {
}

// MARK: - ListPickerInteractor API
extension ListPickerInteractor: ListPickerInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ListPickerInteractor {
    var presenter: ListPickerPresenterApi {
        return _presenter as! ListPickerPresenterApi
    }
}
