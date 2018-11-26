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
    func showHiddenRoutes(delegate: ListPickerDelegate?)
}

//MARK: - ProfileView API
protocol SettingsViewApi: UserInterfaceProtocol {
    func setTitle(title: String?)
    func setFirestoreSyncProgress(message: String, progress: Double)
    func displayTrapperName(name: String?)
    func displayVersionNumbers(appVersion: String, realmVersion: String)
    func displayEmailVisitsRecipient(emailAddress: String?)
    func displayEmailOrdersRecipient(emailAddress: String?)
    func setFocusToRouteName()
}

//MARK: - ProfilePresenter API
protocol SettingsPresenterApi: PresenterProtocol {
    func didSelectClose()
    func didUpdateTrapperName(name: String?)
    func didUpdateEmailVisitsRecipient(emailAddress: String?)
    func didUpdateEmailOrdersRecipient(emailAddress: String?)
    func didClickRealmLabel()
    func didSelectHiddenRoutes()
    func didSelectFirestoreSync()
//    func mergeWithTrapData()
//    func resetAllData()
}

//MARK: - ProfileInteractor API
protocol SettingsInteractorApi: InteractorProtocol {
    func updateDashboardRoutes(routes: [Route], showIndexes: [Int])
    func saveSettings(settings: Settings)
    func getSettings() -> Settings
    func firestoreSync(completion: ((String, Double, Error?) -> Void)?)
}
