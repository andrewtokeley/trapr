//
//  ProfileInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ProfileInteractor Class
final class SettingsInteractor: Interactor {
}

// MARK: - ProfileInteractor API
extension SettingsInteractor: SettingsInteractorApi {
    
    func updateDashboardRoutes(routes: [Route], showIndexes: [Int]) {
        
        for route in routes {
            var show = false
            if let index = routes.index(of: route) {
                if showIndexes.contains(index) {
                    // hide this one
                    show = true
                }
            }
            ServiceFactory.sharedInstance.routeService.updateHiddenFlag(route: route, isHidden: !show)
        }
    }
    
    func saveSettings(settings: Settings) {
        ServiceFactory.sharedInstance.settingsService.addOrUpdate(settings: settings)
    }
    
    func getSettings() -> Settings {
        return ServiceFactory.sharedInstance.settingsService.getSettings()
    }
    
}

// MARK: - Interactor Viper Components Api
private extension SettingsInteractor {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
}
