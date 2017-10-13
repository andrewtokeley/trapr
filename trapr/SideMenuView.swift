//
//  SideMenuView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: SideMenuView Class
final class SideMenuView: UserInterface {
}

//MARK: - SideMenuView API
extension SideMenuView: SideMenuViewApi {
}

// MARK: - SideMenuView Viper Components API
private extension SideMenuView {
    var presenter: SideMenuPresenterApi {
        return _presenter as! SideMenuPresenterApi
    }
    var displayData: SideMenuDisplayData {
        return _displayData as! SideMenuDisplayData
    }
}
