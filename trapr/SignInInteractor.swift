//
//  SignInInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 17/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - SignInInteractor Class
final class SignInInteractor: Interactor {
}

// MARK: - SignInInteractor API
extension SignInInteractor: SignInInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension SignInInteractor {
    var presenter: SignInPresenterApi {
        return _presenter as! SignInPresenterApi
    }
}
