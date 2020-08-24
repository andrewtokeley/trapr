//
//  VisitLogInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import FirebaseAnalytics

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
    func retrieveViewModel(visit: Visit, completion: ((VisitViewModel) -> Void)?) {
        let visitViewModel = VisitViewModel(visit: visit)
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if let lureId = visit.lureId {
            self.getLureDescription(lureId: lureId) { (name) in
                visitViewModel.lureName = name
                dispatchGroup.leave()
            }
        } else {
            self.getDefaultLureDescription(trapTypeId: visit.trapTypeId) { (name) in
                visitViewModel.lureName = name
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            //
            completion?(visitViewModel)
        }
    }
    
    func getDefaultLureDescription(trapTypeId: String, completion: ((String) -> Void)?) {
        trapTypeService.get(id: trapTypeId) { (trapType, error) in
            if let defaultLureId = trapType?.defaultLure {
                self.getLureDescription(lureId: defaultLureId) { (description) in
                    completion?(description)
                }
            } else {
                completion?("None")
            }
        }
    }
    
    func getLureDescription(lureId: String, completion: ((String) -> Void)?) {
        lureService.get(id: lureId) { (lure, error) in
            if let name = lure?.name {
                completion?(name)
            } else {
                completion?("None")
            }
        }
    }
    
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?) {
        stationService.getLureBalance(stationId: stationId, trapTypeId: trapTypeId, asAtDate: asAtDate) { (balance) in
            completion?(balance)
        }
    }
    
    func retrieveLookups(completion: (([TrapType], [Lure], [Species]) -> Void)? ) {
        trapTypeService.get { (trapTypes, error) in
            self.lureService.get { (lures, error) in
                self.speciesService.get { (species, error) in
                    completion?(trapTypes, lures, species)
                }
            }
        }
    }
    
    func retrieveSpeciesList(completion: (([Species]) -> Void)?) {
        speciesService.get { (species, error) in
            completion?(species)
        }
    }
    
    func retrieveLuresList(completion: (([Lure]) -> Void)?) {
        lureService.get { (lures, error) in
            completion?(lures)
        }
    }
    
    func saveVisit(visit: Visit) {
        visitService.add(visit: visit) { (visit, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                //
            }
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitLogInteractor {
    var presenter: VisitLogPresenterApi {
        return _presenter as! VisitLogPresenterApi
    }
}
