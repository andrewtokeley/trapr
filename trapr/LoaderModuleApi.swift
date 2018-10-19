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
    func importProgressReceived(progress: Float)
    func importCompleted()
    func signInStarted()
    func signInFailed()
    func signInComplete()
}

//MARK: - LoaderInteractor API
protocol LoaderInteractorApi: InteractorProtocol {
    func needsDataUpdate() -> Bool
    func verifySignIn(result: ((Bool) -> Void)?)
    func checkForDataUpdates()
}
