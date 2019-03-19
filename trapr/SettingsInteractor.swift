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
    fileprivate let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    fileprivate let userSettingsService = ServiceFactory.sharedInstance.userSettingsService
    
    fileprivate let cacheService = ServiceFactory.sharedInstance.cachePrimerFirestoreService
    fileprivate var reachability: Reachability?
    
    fileprivate func checkConnection(ifOnline: (() -> Void)?, ifOffline: (() -> Void)?) {
        
        // test we can connect to something
        self.reachability = Reachability(hostname: "google.com")
        
        self.reachability?.whenReachable = { reachability in
            ifOnline?()
        }
        
        self.reachability?.whenUnreachable = { _ in
            ifOffline?()
        }
        
        do {
            try self.reachability?.startNotifier()
        } catch {
            ifOffline?()
        }
    }
}

// MARK: - ProfileInteractor API
extension SettingsInteractor: SettingsInteractorApi {
    
//    func firestoreSync(completion: ((String, Double, Error?) -> Void)?) {
//        dataPopulatorService.mergeAllRealmDataToServer { (message, percentage, error) in
//            completion?(message, percentage, error)
//        }
//    }
    
    func doSomething(progress: ((Double, String, Bool) -> Void)?) {
        self.setOwnerToOwnerlessRoutes(progress: progress)
    }
    
    private func setOwnerToOwnerlessRoutes(progress: ((Double, String, Bool) -> Void)?) {
        progress?(0, "We're off...", false)
        routeService._addOwnerToOwnerlessRoutes {
            progress?(1, "Done!", true)
        }
    }
    
    private func refreshCache(progress: ((Double, String, Bool) -> Void)?) {
        progress?(0, "...", false)
        // check we're online
        checkConnection(ifOnline: {
            self.cacheService.primeCache { (percentage, message, finished) in
                progress?(percentage, message, finished)
            }
        }, ifOffline: {
            progress?(0, "Offline, try again later.", true)
        })
    }
    func updateDashboardRoutes(routes: [Route], showIndexes: [Int]) {
        
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
    
    func getRoutes(completion: (([Route]) -> Void)?) {
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
