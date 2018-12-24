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
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let visitSummaryService = ServiceFactory.sharedInstance.visitSummaryFirestoreService
}

// MARK: - StartInteractor API
extension StartInteractor: StartInteractorApi {
    
//    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?) {
//        
//        ServiceFactory.sharedInstance.savedImageService.addOrUpdateSavedImage(asset: asset, completion: {
//            (savedImage) in
//                // let presenter know we've got a new image.
//                ServiceFactory.sharedInstance.routeService.updateDashboardImage(route: route, savedImage: savedImage)
//            
//                completion?()
//            })
//    }
    
    func getNewVisitSummary(date: Date, routeId: String, completion: ((_VisitSummary?) -> Void)?) {
        visitSummaryService.createNewVisitSummary(date: date, routeId: routeId) { (visitSummary, error) in
            completion?(visitSummary)
        }
    }
    
    func getMostRecentVisitSummary(routeId: String, completion: ((_VisitSummary?) -> Void)?) {
        self.visitSummaryService.get(mostRecentOn: routeId) { (visitSummary, error) in
            completion?(visitSummary)
        }
    }
    
    func getLastVisitedDateDescription(routeId: String, completion: ((String) -> Void)?) {
        self.routeService.daysSinceLastVisitDescription(routeId: routeId) { (description) in
            completion?(description)
        }
    }
    
    func initialiseHomeModule() {
    
        // Get all the (unhidden) routes
        routeService.get(includeHidden: false) { (routes, error) in
            
            // order by last visit
//            let orderedRoutes = routes.sorted(by: {
//                (r1, r2) in
//
//                let lastVisited1 = self.getLastVisitedDateDescription(route: r1)
//                let lastVisited2 = self.getLastVisitedDateDescription(route: r2)
//
//                return lastVisited1 > lastVisited2
//
//            }, stable: true)
            
            // Let the presenter know what routes to display
            let dispatchGroup = DispatchGroup()
            var lastVisitedDescriptions = [String]()
            for route in routes {
                dispatchGroup.enter()
                self.getLastVisitedDateDescription(routeId: route.id!, completion: { (description) in
                    lastVisitedDescriptions.append(description)
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main) {
                self.presenter.setRoutes(routes: routes, lastVisitDescriptions: lastVisitedDescriptions)
            }
        }
        
    }
    
    func deleteRoute(routeId: String) {
        routeService.delete(routeId: routeId, completion: nil)
    }
}

// MARK: - Interactor Viper Components Api
private extension StartInteractor {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
}
