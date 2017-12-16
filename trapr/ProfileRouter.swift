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
final class ProfileRouter: Router {
}

// MARK: - ProfileRouter API
extension ProfileRouter: ProfileRouterApi {
}

// MARK: - Profile Viper Components
private extension ProfileRouter {
    var presenter: ProfilePresenterApi {
        return _presenter as! ProfilePresenterApi
    }
}
