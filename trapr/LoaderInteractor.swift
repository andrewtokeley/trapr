//
//  LoaderInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import FirebaseAuth

// MARK: - LoaderInteractor Class
final class LoaderInteractor: Interactor {
    
    fileprivate let userService = ServiceFactory.sharedInstance.userService
    
}

// MARK: - LoaderInteractor API
extension LoaderInteractor: LoaderInteractorApi {
    
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func registerAuthenticatedUser(completion: @escaping(User?) -> Void) {
        
        // Make sure we have a record in the database for the user
        if let authUser = Auth.auth().currentUser, let email = authUser.email {
            let authenticatedUser = AuthenticatedUser(email: email)
            
            userService.registerAuthenticatedUser(authenticatedUser: authenticatedUser) { (user, error) in
                
                completion(user)
            }
        }
    }
    
    func needsDataUpdate() -> Bool {
        
        // for now we simply assume that if no traplines are present we need to update the app data
        //let traplines = ServiceFactory.sharedInstance.traplineService.getTraplines() ?? [Trapline]()
        
        // the only exception to this is if we're running in test mode. In this case don't suggest a data update
        let runningInTestMode = ServiceFactory.sharedInstance.runningInTestMode
        
        //return traplines.count == 0 && !runningInTestMode
        
        // FOR NOW, ALWAYS MERGE UNLESS IN TEST MODE!
        return true && !runningInTestMode
    }
    
    
    func checkForDataUpdates() {
        ServiceFactory.sharedInstance.dataPopulatorService.mergeWithV1Data(
            progress: {
                (progress) in
                self.presenter.importProgressReceived(progress: progress)
        }, completion: {
                (importSummary) in
                self.presenter.importCompleted()
        })
    }
}

// MARK: - Interactor Viper Components Api
private extension LoaderInteractor {
    var presenter: LoaderPresenterApi {
        return _presenter as! LoaderPresenterApi
    }
}
