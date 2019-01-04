//
//  SideMenuInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import FirebaseAuth

// MARK: - SideMenuInteractor Class
final class SideMenuInteractor: Interactor {
    fileprivate let stationService = ServiceFactory.sharedInstance.stationFirestoreService
}

// MARK: - SideMenuInteractor API
extension SideMenuInteractor: SideMenuInteractorApi {
    
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getStationsForMap(completion: (([_Station]) -> Void)?) {
        stationService.get { (stations) in
            completion?(stations)
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension SideMenuInteractor {
    var presenter: SideMenuPresenterApi {
        return _presenter as! SideMenuPresenterApi
    }
}
