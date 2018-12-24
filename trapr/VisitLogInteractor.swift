//
//  VisitLogInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitLogInteractor Class
final class VisitLogInteractor: Interactor {
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let lureService = ServiceFactory.sharedInstance.lureFirestoreService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
}

// MARK: - VisitLogInteractor API
extension VisitLogInteractor: VisitLogInteractorApi {
    
//    func deleteVisit(visit: Visit) {
//        ServiceFactory.sharedInstance.visitService.delete(visit: visit)
//    }
    
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?) {
        stationService.getLureBalance(stationId: stationId, trapTypeId: trapTypeId, asAtDate: asAtDate) { (balance) in
            completion?(balance)
        }
    }
    
    func retrieveTrapTypes(completion: (([_TrapType]) -> Void)? ) {
        trapTypeService.get { (trapTypes, error) in
            completion?(trapTypes)
        }
    }
    
    func retrieveSpeciesList(completion: (([_Species]) -> Void)?) {
        speciesService.get { (species, error) in
            completion?(species)
        }
    }
    
    func retrieveLuresList(completion: (([_Lure]) -> Void)?) {
        lureService.get { (lures, error) in
            completion?(lures)
        }
    }
    
    func saveVisit(visit: _Visit) {
        visitService.add(visit: visit, completion: nil)
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitLogInteractor {
    var presenter: VisitLogPresenterApi {
        return _presenter as! VisitLogPresenterApi
    }
}
