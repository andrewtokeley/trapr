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
    func showModule(menuItem: MenuItem) {
        
    }
}

// MARK: - SideMenu Viper Components
private extension SideMenuRouter {
    var presenter: SideMenuPresenterApi {
        return _presenter as! SideMenuPresenterApi
    }
}
