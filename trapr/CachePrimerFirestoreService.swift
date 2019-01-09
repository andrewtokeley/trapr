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
        
        self.cachePrimed { (cachePrimed) in
            
            if !cachePrimed {
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
    
    /// Returns whether the app has been primed already. If true, basic lookup and station data is present and the app will function fine, even if offline. If false, the cache must be primed before the app run.
    func cachePrimed(completion: ((Bool) -> Void)?) {
        
        // Since primeCache loads all core data, we assume if there are species in the cache then the rest of the core data will be present too
        speciesService.source = .cache
        speciesService.get { (species, error) in
            completion?(species.count != 0)
        }
    }
    
}
