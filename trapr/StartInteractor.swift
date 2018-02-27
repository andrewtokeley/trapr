//
//  StartInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import Photos

// MARK: - StartInteractor Class
final class StartInteractor: Interactor {
}

// MARK: - StartInteractor API
extension StartInteractor: StartInteractorApi {
    
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?) {
        
        ServiceFactory.sharedInstance.savedImageService.addOrUpdateSavedImage(asset: asset, completion: {
            (savedImage) in
                // let presenter know we've got a new image.
                ServiceFactory.sharedInstance.routeService.updateDashboardImage(route: route, savedImage: savedImage)
            
                completion?()
            })
    }
    
    func getLastVisitedDateDescription(route: Route) -> String {
        
        let service = ServiceFactory.sharedInstance.routeService
        return service.daysSinceLastVisitDescription(route: route)
    }
    
    func initialiseHomeModule() {
    
        // Get all the (unhidden) routes
        let routes = ServiceFactory.sharedInstance.routeService.getAll(includeHidden: false)
        
        // Let the presenter know what routes to display
        presenter.setRoutes(routes: routes)
    }
    
    func deleteRoute(route: Route) {
        ServiceFactory.sharedInstance.routeService.delete(route: route)
    }
}

// MARK: - Interactor Viper Components Api
private extension StartInteractor {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
}
