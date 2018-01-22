//
//  LoaderRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoaderRouter class
final class LoaderRouter: Router {
}

// MARK: - LoaderRouter API
extension LoaderRouter: LoaderRouterApi {
    func showStartModule() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let module = AppModules.start.build()
        module.router.show(inWindow: window, embedInNavController: true, setupData: nil, makeKeyAndVisible: true)
    }
}

// MARK: - Loader Viper Components
private extension LoaderRouter {
    var presenter: LoaderPresenterApi {
        return _presenter as! LoaderPresenterApi
    }
}
