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
}

// MARK: - VisitLogInteractor API
extension VisitLogInteractor: VisitLogInteractorApi {
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
    
    func saveVisit(visit: Visit) {
        let service = ServiceFactory.sharedInstance.visitService
        service.save(visit: visit)
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitLogInteractor {
    var presenter: VisitLogPresenterApi {
        return _presenter as! VisitLogPresenterApi
    }
}
