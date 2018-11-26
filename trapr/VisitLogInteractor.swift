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
}

// MARK: - VisitLogInteractor API
extension VisitLogInteractor: VisitLogInteractorApi {
    
//    func deleteVisit(visit: Visit) {
//        ServiceFactory.sharedInstance.visitService.delete(visit: visit)
//    }
    
    func retrieveSpeciesList(callback: ([Species]) -> Void) {
        
        let service = ServiceFactory.sharedInstance.speciesService
        let species = service.getAll()
        callback(species)
    }
    
    func retrieveLuresList(callback: ([Lure]) -> Void) {
        
        let service = ServiceFactory.sharedInstance.lureService
        let species = service.getAll()
        callback(species)
    }
    
    func saveVisit(visit: Visit) -> Visit {

        // TEMP
        if let visitFS = ModelConverter.Visit(visit) {
            visitService.add(visit: visitFS, completion: nil)
        }
        
        let service = ServiceFactory.sharedInstance.visitService
        return service.save(visit: visit)
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitLogInteractor {
    var presenter: VisitLogPresenterApi {
        return _presenter as! VisitLogPresenterApi
    }
}
