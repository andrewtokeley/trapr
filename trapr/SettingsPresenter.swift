//
//  SettingsPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 25/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class SettingsPresenter: SettingsModuleInterface {
    
    var router: SettingsWireframeInput?
    var view: SettingsViewInterface?
    
    func viewWillAppear() {
        view?.setTitle(title: "Settings")
    }
    
    func didSelectClose() {
        router?.dismissView()
    }
    
    func didSelectResetData() {
        ServiceFactory.sharedInstance.dataPopulatorService.populateWithTestData()
    }
}
