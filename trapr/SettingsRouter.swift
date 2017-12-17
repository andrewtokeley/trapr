//
//  ProfileRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ProfileRouter class
final class SettingsRouter: Router {
}

// MARK: - ProfileRouter API
extension SettingsRouter: SettingsRouterApi {
}

// MARK: - Profile Viper Components
private extension SettingsRouter {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
}
