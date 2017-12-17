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
