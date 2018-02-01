//
//  LoaderInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoaderInteractor Class
final class LoaderInteractor: Interactor {
}

// MARK: - LoaderInteractor API
extension LoaderInteractor: LoaderInteractorApi {
    
    func checkForUpdates() {

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
