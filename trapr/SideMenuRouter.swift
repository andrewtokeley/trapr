//
//  SideMenuRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - SideMenuRouter class
final class SideMenuRouter: Router {
    
}

// MARK: - SideMenuRouter API
extension SideMenuRouter: SideMenuRouterApi {
    func showModule(menuItem: SideBarMenuItem) {
        if menuItem == .Settings {
            let module = AppModules.settings.build()
            if let presentingViewController = viewController.presentingViewController {
                module.router.show(from: presentingViewController, embedInNavController: true, setupData: nil)
            }
        }
    }
    
    func dismiss(completion: (() -> Void)?) {
        viewController.dismiss(animated: false, completion: completion)
    }
}

// MARK: - SideMenu Viper Components
private extension SideMenuRouter {
    var presenter: SideMenuPresenterApi {
        return _presenter as! SideMenuPresenterApi
    }
}
