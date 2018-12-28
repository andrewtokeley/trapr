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
    
    override func setupView(data: Any) {
        if let setupData = data as? LoaderPresenterSetupData {
            self.delegate = setupData.delegate
        }
    }
    override func viewHasLoaded() {
        interactor.registerAuthenticatedUser { (user) in
            
            // check whether there is a user already authenticated
            if self.interactor.isAuthenticated {
                
                // no need to show the signin button
                self.view.showSignInButton(show: false)
                
                // TODO: won't need this and can replace with call to fade()
                self.primeCache()
                
            } else {
                
                self.view.showSignInButton(show: true)
            }
        }
    }

    fileprivate func primeCache() {
        interactor.primeCache()
    }
    
    fileprivate func fade() {
        view.fade(completion: {
            self._view.dismiss(animated: true, completion: {
                
                self.delegate?.loaderAboutToClose()
                
                self._view.dismiss(animated: true, completion: nil)
            })
        })
    }
}

// MARK: - LoaderPresenter API
extension LoaderPresenter: LoaderPresenterApi {
    
    func loadProgressReceived(progress: Float, message: String) {
        view.updateProgress(progress: progress)
        view.updateProgressMessage(message: message)
    }
    
    func loadCompleted() {
        // complete the progress meter
        view.updateProgress(progress: 1)
        
        fade()
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
