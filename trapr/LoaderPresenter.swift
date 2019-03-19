//
//  LoaderPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoaderPresenter Class
final class LoaderPresenter: Presenter {

    fileprivate var delegate: LoaderDelegate?
    fileprivate var reachability: Reachability?
    fileprivate let cacheService = ServiceFactory.sharedInstance.cachePrimerFirestoreService
    fileprivate let OFFLINE_FOR_FIRST_USE_MESSAGE = "When you first use Trapr you must be online. \nTry again when you have a connection."
    fileprivate let START_ERROR_MESSAGE = "Well, that wasn't meant to happen. \nThe App can't start at the moment, close it and try again."
    override func setupView(data: Any) {
//        if let setupData = data as? LoaderPresenterSetupData {
//            self.delegate = setupData.delegate
//        }
        
       
    }

    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        checkConnection()
        
//        let dispatchGroup = DispatchGroup()
//        
//        if !interactor.isInTestMode {
//            checkConnection()
//        } else {
//            // if testing, prime the cache and don't finish the load event until it's done. This ensure the cache is fully primed before any tests run.
//            dispatchGroup.enter()
//            self.ifOnline(primeCache: true) {
//                dispatchGroup.leave()
//            }
//        }
//        
//        print("waiting...")
//        dispatchGroup.wait()
//        print("done!")
        
    }
    
    fileprivate func checkConnection(completion: (() -> Void)? = nil) {
        
        // test we can connect to something
        self.reachability = Reachability(hostname: "google.com")
        
        self.reachability?.whenReachable = { _ in
            self.ifOnline(primeCache: true, completion: completion)
        }
        
        self.reachability?.whenUnreachable = { _ in
            self.ifOffline(completion: completion)
        }
        
        do {
            try self.reachability?.startNotifier()
        } catch {
            self.view.updateProgressMessage(message: self.START_ERROR_MESSAGE)
        }
    }
    
    fileprivate func ifOffline(completion: (() -> Void)? = nil) {
        // it's ok to be offline if the cache has been primed.
        cacheService.cachePrimed { (isCachePrimed) in
            if !isCachePrimed {
                self.view.updateProgressMessage(message: self.OFFLINE_FOR_FIRST_USE_MESSAGE)
                completion?()
            } else {
                // Offline but core data is present in the cache, so let them through as if they were online but don't bother trying to prime the cache
                self.ifOnline(primeCache: false, completion: completion)
            }
        }
    }
    
    fileprivate func ifOnline(primeCache: Bool, completion: (() -> Void)? = nil) {
    
        view.updateProgressMessage(message: "")
        interactor.registerAuthenticatedUser { (user) in
            
            // check whether there is a user already authenticated
            if self.interactor.isAuthenticated {
                
                // no need to show the signin button
                self.view.showSignInButton(show: false)
                
                // TODO: won't need this and can replace with call to fade()
                if primeCache {
                    self.primeCache(completion: completion)
                } else {
                    completion?()
                    self.fadeAndNavigateAway()
                }
            
            } else {
                self.view.showSignInButton(show: true)
                completion?()
            }
        }
    }
    
    fileprivate func primeCache(completion: (() -> Void)? = nil) {
        interactor.primeCache(completion: completion)
    }
    
    /// Fade the view and navigate away to the Start module
    fileprivate func fadeAndNavigateAway() {
        view.fade(completion: {
            self.router.showStartModule()
        })
    }
}

// MARK: - LoaderPresenter API
extension LoaderPresenter: LoaderPresenterApi {
    
    func loadProgressReceived(progress: Float, message: String) {
        view.updateProgress(progress: progress)
        view.updateProgressMessage(message: message)
    }
    
    func primeCacheCompleted() {
        // complete the progress meter
        view.updateProgress(progress: 1)
        
        // fade and navigate to Start module
        fadeAndNavigateAway()
    }
    
    func signInStarted() {
        // hide the signin button
        view.showSignInButton(show: false)
    }
    
    func signInFailed(error: Error) {
        // hide the signin button
        view.showSignInButton(show: true)
        view.updateProgressMessage(message: error.localizedDescription)
    }
    
    func signInComplete() {
        // make sure the user is registered with the app
        interactor.registerAuthenticatedUser { (user) in
            // make sure the newly signed in user gets their cache primed
            self.primeCache()
        }
    }

}

// MARK: - Loader Viper Components
private extension LoaderPresenter {
    var view: LoaderViewApi {
        return _view as! LoaderViewApi
    }
    var interactor: LoaderInteractorApi {
        return _interactor as! LoaderInteractorApi
    }
    var router: LoaderRouterApi {
        return _router as! LoaderRouterApi
    }
}
