//
//  ProfileModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - ProfileRouter API
protocol SettingsRouterApi: RouterProtocol {
}

//MARK: - ProfileView API
protocol SettingsViewApi: UserInterfaceProtocol {
    func setTitle(title: String?)
    func displayTrapperName(name: String?)
    func displayAppVersion(version: String)
    func displayRealmVersion(version: String)
    func setFocusToRouteName()
}

//MARK: - ProfilePresenter API
protocol SettingsPresenterApi: PresenterProtocol {
    func didSelectClose()
    func didUpdateTrapperName(name: String?)
    func mergeWithTrapData()
}

//MARK: - ProfileInteractor API
protocol SettingsInteractorApi: InteractorProtocol {
    func saveSettings(settings: Settings)
    func getSettings() -> Settings
}
