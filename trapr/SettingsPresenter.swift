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
    
    fileprivate var settings: UserSettings!
    //fileprivate var appSettings: ApplicationSettings!
    
    fileprivate var routes = [_Route]()
    
    override func viewHasLoaded() {
        // taking a shallow copy like this allows the object's properties to be updated - Realm doesn't allow this outside of realm.write
        interactor.get { (settings) in
            self.settings = settings
//            self.view.displayVersionNumbers(appVersion: settings.appVersion ?? "-", realmVersion: settings.realmVersion ?? "-")
            self.view.displayEmailOrdersRecipient(emailAddress: self.settings.orderEmail)
            self.view.displayEmailVisitsRecipient(emailAddress: self.settings.handlerEmail)
            self.view.setTitle(title: "Settings")
        }
    }
    
}

extension SettingsPresenter: ListPickerDelegate {
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        return "Routes"
    }
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        return "Show on Dashboard"
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        return routes[index].name
    }
    
    func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool {
        return !routes[index].hidden
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        return routes.count
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectMultipleItemsAt indexes: [Int]) {
        interactor.updateDashboardRoutes(routes: self.routes, showIndexes: indexes)
    }
    
}

// MARK: - ProfilePresenter API
extension SettingsPresenter: SettingsPresenterApi {
    
    func didSelectHiddenRoutes() {
        
        // make sure routes list
        interactor.getRoutes { (routes) in
            self.routes = routes
            self.router.showHiddenRoutes(delegate: self)
        }
    }
    
    func didClickRealmLabel() {
        UIPasteboard.general.string = ServiceFactory.sharedInstance.realm.configuration.fileURL?.relativePath
    }
    
    func didSelectClose() {
        _view.view.endEditing(true)

        interactor.save(settings: self.settings)
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectFirestoreSync() {
        _view.presentConfirmation(title: "Firestore Sync", message: "This will merge the route, stations and all visits to the server. Do you want to continue?", response: {
            (response) in
            if response {

                self.interactor.firestoreSync { (message, progress, error) in
                    self.view.setFirestoreSyncProgress(message: message, progress: progress)
                    print("\(message): \(progress)")
                }
            }
        })
    }

//    func didUpdateTrapperName(name: String?) {
//        self.settings.username = name
//    }
    
    func didUpdateEmailOrdersRecipient(emailAddress: String?) {
        self.settings.orderEmail = emailAddress
    }
    
    func didUpdateEmailVisitsRecipient(emailAddress: String?) {
        self.settings.handlerEmail = emailAddress
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
