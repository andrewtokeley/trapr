//
//  SignInPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 17/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import GTMOAuth2

// MARK: - SignInPresenter Class
final class SignInPresenter: Presenter {
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        
    }
}

// MARK: - SignInPresenter API
extension SignInPresenter: SignInPresenterApi {
}

// MARK: - SignIn Viper Components
private extension SignInPresenter {
    var view: SignInViewApi {
        return _view as! SignInViewApi
    }
    var interactor: SignInInteractorApi {
        return _interactor as! SignInInteractorApi
    }
    var router: SignInRouterApi {
        return _router as! SignInRouterApi
    }
}
