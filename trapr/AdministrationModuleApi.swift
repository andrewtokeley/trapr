//
//  AdministrationModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - AdministrationRouter API
protocol AdministrationRouterApi: RouterProtocol {
}

//MARK: - AdministrationView API
protocol AdministrationViewApi: UserInterfaceProtocol {
    func showProductionWarning()
}

//MARK: - AdministrationPresenter API
protocol AdministrationPresenterApi: PresenterProtocol {
    func didSelectClose()
    
    func didSelectImport()
}

//MARK: - AdministrationInteractor API
protocol AdministrationInteractorApi: InteractorProtocol {
    func mergeDataFromCSVToDatastore()
}
