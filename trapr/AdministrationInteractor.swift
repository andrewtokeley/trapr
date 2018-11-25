//
//  AdministrationInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - AdministrationInteractor Class
final class AdministrationInteractor: Interactor {
}

// MARK: - AdministrationInteractor API
extension AdministrationInteractor: AdministrationInteractorApi {
    
    func mergeDataFromCSVToDatastore() {
//        ServiceFactory.sharedInstance.dataPopulatorService.mergeWithV1Data(
//            progress: {
//                (progress) in
//                self.presenter.importProgressReceived(progress: progress)
//        }, completion: {
//            (importSummary) in
//            self.presenter.importCompleted()
//        })
    }
    
}

// MARK: - Interactor Viper Components Api
private extension AdministrationInteractor {
    var presenter: AdministrationPresenterApi {
        return _presenter as! AdministrationPresenterApi
    }
}
