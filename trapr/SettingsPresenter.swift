//
//  ProfilePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ProfilePresenter Class
final class SettingsPresenter: Presenter {
    
    fileprivate var settings: Settings!
    
    override func viewHasLoaded() {
        // taking a shallow copy like this allows the object's properties to be updated - Realm doesn't allow this outside of realm.write
        self.settings = Settings(value: interactor.getSettings())
        view.displayTrapperName(name: settings.username)
        view.displayAppVersion(version: settings.appVersion ?? "-")
        view.displayRealmVersion(version: settings.realmVersion ?? "-")
        view.setTitle(title: "Settings")
    }
    
}

// MARK: - ProfilePresenter API
extension SettingsPresenter: SettingsPresenterApi {
    
    func didSelectClose() {
        _view.view.endEditing(true)

        interactor.saveSettings(settings: self.settings)
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didUpdateTrapperName(name: String?) {
        self.settings.username = name
    }
    
    func mergeWithTrapData() {
        let service = ServiceFactory.sharedInstance.dataPopulatorService
        service.mergeWithV1Data()
    }
    
}

// MARK: - Profile Viper Components
private extension SettingsPresenter {
    var view: SettingsViewApi {
        return _view as! SettingsViewApi
    }
    var interactor: SettingsInteractorApi {
        return _interactor as! SettingsInteractorApi
    }
    var router: SettingsRouterApi {
        return _router as! SettingsRouterApi
    }
}
