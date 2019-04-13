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
    fileprivate let cachePrimerService = ServiceFactory.sharedInstance.cachePrimerFirestoreService
}

// MARK: - LoaderInteractor API
extension LoaderInteractor: LoaderInteractorApi {
    
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var isInTestMode: Bool {
        return ServiceFactory.sharedInstance.runningInTestMode
    }
    
    func registerAuthenticatedUser(completion: @escaping(User?) -> Void) {
        
        // Make sure we have a record in the database for the user
        
        if let authUser = Auth.auth().currentUser, let email = authUser.email {
            
            let authenticatedUser = AuthenticatedUser(email: email)
            authenticatedUser.displayName = authUser.displayName
            
            userService.registerAuthenticatedUser(authenticatedUser: authenticatedUser) { (user, error) in
                print("got user")
                completion(user)
            }
        } else {
            // user isn't signed in
            completion(nil)
        }
    }
    
    func primeCache(completion: (() -> Void)? = nil) {
        cachePrimerService.primeCache { (progress, message, finished) in
            self.presenter.loadProgressReceived(progress: Float(progress), message: message)
            if finished {
                self.presenter.primeCacheCompleted()
                completion?()
            }
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension LoaderInteractor {
    var presenter: LoaderPresenterApi {
        return _presenter as! LoaderPresenterApi
    }
}
