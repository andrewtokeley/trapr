//
//  LoaderModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - LoaderRouter API
protocol LoaderRouterApi: RouterProtocol {
    func showStartModule()
}

//MARK: - LoaderView API
protocol LoaderViewApi: UserInterfaceProtocol {
    func updateProgress(progress: Float)
    func updateProgressMessage(message: String?)
    func fade(completion: (() -> Void)?)
    func showSignInButton(show: Bool)
}

//MARK: - LoaderPresenter API
protocol LoaderPresenterApi: PresenterProtocol {
    
    /**
    Called by the view to periodically let the presenter know the import progress
     */
    func loadProgressReceived(progress: Float, message: String )
    
    /**
     Called by the interactor to let the Presenter know the cache has been primed.
     */
    func primeCacheCompleted()
    
    /**
     Called by the view to let the presenter know that the user has selected the Sign In button to start the authentication process.
     */
    func signInStarted()

    /**
     Called by the view to let the presenter know a user tried but failed to sign in
     */
    func signInFailed(error: Error)
    
    /**
    Called by the view to let the presenter know the user has successfully authenticated themselves to the app.
     */
    func signInComplete()
}

//MARK: - LoaderInteractor API
protocol LoaderInteractorApi: InteractorProtocol {
    
    /**
     Primes the app's cache to allow it to work offline
     */
    func primeCache()
    
    /**
     Returns whether the user is already authenticated. This means they have logged in and been registered with the app already.
     */
    var isAuthenticated: Bool { get }
    
    /**
    Calling this method ensures a user record exists database and that UserService.currentUser is instantiated for the authenticated user.
    */
    func registerAuthenticatedUser(completion: @escaping(User?) -> Void)
}
