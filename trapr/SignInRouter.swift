//
//  SignInRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 17/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - SignInRouter class
final class SignInRouter: Router {
}

// MARK: - SignInRouter API
extension SignInRouter: SignInRouterApi {
}

// MARK: - SignIn Viper Components
private extension SignInRouter {
    var presenter: SignInPresenterApi {
        return _presenter as! SignInPresenterApi
    }
}
