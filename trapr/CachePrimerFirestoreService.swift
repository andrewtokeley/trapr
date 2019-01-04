//
//  CachePrimerFirestoreService.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 20/12/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class CachePrimerFirestoreService: CachePrimerServiceInterface {
    
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let userService = ServiceFactory.sharedInstance.userService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let lureService = ServiceFactory.sharedInstance.lureFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    
    // MUST BE 7 MESSAGES!
    private let loadingMessage = [
        "One moment",
        "One moment",
        "Almost there",
        "Almost there",
        "and...",
        "and...",
        "Done!"
    ]
    
    func primeCache(progress: ((Double, String) -> Void)?) {
        
        self.mustPrimeCache { (result) in
            let mustPrime = result
            
            if mustPrime {
                // there are 6 key entities to read into the cache
                // Regions, Traplines, Stations, Lookups (3)
                let steps: Double = 6
                var currentStep: Double = 0
                // force reading from the server
                progress?(currentStep/steps, self.loadingMessage[Int(currentStep)])
                self.speciesService.get(source: .server, completion: { (species, error) in
                    currentStep += 1
                    progress?(currentStep/steps, self.loadingMessage[Int(currentStep)])
                    self.lureService.get(source: .server, completion: { (species, error) in
                        currentStep += 1
                        progress?(currentStep/steps, self.loadingMessage[Int(currentStep)])
                        self.trapTypeService.get(source: .server, completion: { (species, error) in
                            currentStep += 1
                            progress?(currentStep/steps, self.loadingMessage[Int(currentStep)])
                            self.regionService.get(source: .server, completion: { (species, error) in
                                currentStep += 1
                                progress?(currentStep/steps, self.loadingMessage[Int(currentStep)])
                                
                                self.traplineService.get(source: .server, completion: { (species) in
                                    currentStep += 1
                                    progress?(currentStep/steps, self.loadingMessage[Int(currentStep)])
                                    self.stationService.get(source: .server, completion: { (stations) in
                                        currentStep += 1
                                        progress?(1, self.loadingMessage[Int(currentStep)])
                                    })
                                })
                            })
                        })
                    })
                })
            } else {
                progress?(1, "Done")
            }
            
        }
    }
    
    /// Returns whether the app must prime the cache, for example, if this is the first time the app has been run we have to get some data in for the user to continue.
    private func mustPrimeCache(completion: ((Bool) -> Void)?) {
//        speciesService.source = .cache
//        speciesService.get { (species, error) in
//            completion?(species.count == 0)
//        }
        // TODO: should change to be smarter to only check if something's changed in core data
        completion?(true)
    }
    
    
}
