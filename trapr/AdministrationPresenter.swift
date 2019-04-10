//
//  AdministrationPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - AdministrationPresenter Class
final class AdministrationPresenter: Presenter {
    
    override func viewIsAboutToAppear() {
        _view.setTitle(title: "Administration")
        
        #if DEVELOPMENT
        #else
            view.showProductionWarning()
        #endif
    }
    
}

// MARK: - AdministrationPresenter API
extension AdministrationPresenter: AdministrationPresenterApi {
    
    func didSelectClose() {
        view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func didSelectImport() {
        interactor.mergeDataFromCSVToDatastore()
    }
}

// MARK: - Administration Viper Components
private extension AdministrationPresenter {
    var view: AdministrationViewApi {
        return _view as! AdministrationViewApi
    }
    var interactor: AdministrationInteractorApi {
        return _interactor as! AdministrationInteractorApi
    }
    var router: AdministrationRouterApi {
        return _router as! AdministrationRouterApi
    }
}
