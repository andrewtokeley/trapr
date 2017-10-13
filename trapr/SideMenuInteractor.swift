//
//  SideMenuInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - SideMenuInteractor Class
final class SideMenuInteractor: Interactor {
}

// MARK: - SideMenuInteractor API
extension SideMenuInteractor: SideMenuInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension SideMenuInteractor {
    var presenter: SideMenuPresenterApi {
        return _presenter as! SideMenuPresenterApi
    }
}
