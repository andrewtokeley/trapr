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
    
    func showHiddenRoutes(delegate: ListPickerDelegate?) {
        let module = AppModules.listPicker.build()
        
        let setupData = ListPickerSetupData()
        setupData.enableMultiselect = true
        setupData.delegate = delegate
        setupData.includeSelectNone = false
        
        setupData.embedInNavController = false 
        module.router.show(from: viewController, embedInNavController: false, setupData: setupData)
    }
    
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
