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
    fileprivate let dataPopulatorService = ServiceFactory.sharedInstance.dataPopulatorFirestoreService
    fileprivate let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    fileprivate let userSettingsService = ServiceFactory.sharedInstance.userSettingsService
}

// MARK: - ProfileInteractor API
extension SettingsInteractor: SettingsInteractorApi {
    
//    func firestoreSync(completion: ((String, Double, Error?) -> Void)?) {
//        dataPopulatorService.mergeAllRealmDataToServer { (message, percentage, error) in
//            completion?(message, percentage, error)
//        }
//    }
    
    func updateDashboardRoutes(routes: [_Route], showIndexes: [Int]) {
        
        for route in routes {
            var show = false
            if let index = routes.index(of: route) {
                if showIndexes.contains(index) {
                    // hide this one
                    show = true
                }
                routeService.updateHiddenFlag(routeId: route.id! , isHidden: !show, completion: nil)
            }
            
        }
    }
    func save(settings: UserSettings) {
        userSettingsService.add(userSettings: settings, completion: nil)
    }

    func get(completion: ((UserSettings?) -> Void)?) {
        userSettingsService.get { (settings, error) in
            completion?(settings)
        }
    }
    
    func getRoutes(completion: (([_Route]) -> Void)?) {
        routeService.get { (routes, error) in
            completion?(routes)
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension SettingsInteractor {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
}
