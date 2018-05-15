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
    
    /**
    Determines whether the app data needs to be updated.
    */
    func needsDataUpdate() -> Bool {
        
        // for now we simply assume that if no traplines are present we need to update the app data
        let traplines = ServiceFactory.sharedInstance.traplineService.getTraplines() ?? [Trapline]()
        
        // the only exception to this is if we're running in test mode. In this case don't suggest a data update
        let runningInTestMode = ServiceFactory.sharedInstance.runningInTestMode
        
        return traplines.count == 0 && !runningInTestMode
    }
    
    /**
    Checks for data updates. Note this does not check whether an update is required. Use needsDataUpdate for this purpose.
     */
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
