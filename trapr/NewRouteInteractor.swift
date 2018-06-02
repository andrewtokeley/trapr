//
//  NewRouteInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewRouteInteractor Class
final class NewRouteInteractor: Interactor {
}

// MARK: - NewRouteInteractor API
extension NewRouteInteractor: NewRouteInteractorApi {
    
    func retrieveTraplines(region: Region) {
        let traplines = ServiceFactory.sharedInstance.traplineService.getTraplines(region: region)
        presenter.didFetchTraplines(traplines: traplines ?? [Trapline]())
    }
    
    func retrieveRegions() {
        let regions = ServiceFactory.sharedInstance.regionService.getRegions()
        presenter.didFetchRegions(regions: regions ?? [Region]())
    }
}

// MARK: - Interactor Viper Components Api
private extension NewRouteInteractor {
    var presenter: NewRoutePresenterApi {
        return _presenter as! NewRoutePresenterApi
    }
}
