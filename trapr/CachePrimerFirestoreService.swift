//
//  CachePrimerFirestoreService.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 20/12/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class CachePrimerFirestoreService: CachePrimerServiceInterface {
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let userService = ServiceFactory.sharedInstance.userService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let lureService = ServiceFactory.sharedInstance.lureFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    
    // there are 11 server actions to prime the cache
    // Get Visits, Routes, Regions, Traplines, Stations, Create DefaultLookup Values (3), Lookups (3)
    // If you don't update this number things will still work but the percentage complete will not look right
    private let NUMBER_OF_STEPS = 11
    
    // If, the number of steps exceeds the number of loadingMessages, we'll use the message at this index
    private let DEFAULT_MESSAGE_INDEX = 6
    
    // Messages that will be displayed to the user, at each step, as we load the cache
    private let loadingMessages = [
        "one moment",
        "one moment",
        "one moment",
        "almost there",
        "almost there",
        "almost there",
        "and...",
        "done!"
    ]
    
    private func progressAtStep(_ step: Int) -> Double {
        if step < NUMBER_OF_STEPS {
            return Double(step)/Double(NUMBER_OF_STEPS)
        } else {
            return 1
        }
    }
    
    private func messageAtStep(_ step: Int) -> String {
        if step >= NUMBER_OF_STEPS - 2 {
            return loadingMessages.last!
        } else if step < loadingMessages.count - 1 {
            return loadingMessages[step]
        } else {
            return loadingMessages[DEFAULT_MESSAGE_INDEX]
        }
    }
    
    func primeCache(progress: ((Double, String) -> Void)?) {
        
        self.cachePrimed { (cachePrimed) in
            
            if !cachePrimed {
                var currentStep = 0
                progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                
                // force reading data from the server
                self.visitService.get(source: .server, completion: { (entities) in
                    currentStep += 1
                    progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                    self.routeService.get(source: .server, completion: { (entities, error) in
                        currentStep += 1
                        progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                        self.speciesService.createOrUpdateDefaults(completion: {
                            currentStep += 1
                            progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                            self.speciesService.get(source: .server, completion: { (entities, error) in
                                currentStep += 1
                                progress?(self.progressAtStep(currentStep), self.messageAtStep(Int(currentStep)))
                                self.lureService.createOrUpdateDefaults(completion: {
                                    currentStep += 1
                                    progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                                    self.lureService.get(source: .server, completion: { (entities, error) in
                                        currentStep += 1
                                        progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                                        self.trapTypeService.createOrUpdateDefaults(completion: {
                                            currentStep += 1
                                            progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                                            self.trapTypeService.get(source: .server, completion: { (entities, error) in
                                                currentStep += 1
                                                progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                                                self.regionService.get(source: .server, completion: { (entities, error) in
                                                    currentStep += 1
                                                    progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                                                    
                                                    self.traplineService.get(source: .server, completion: { (entities) in
                                                        currentStep += 1
                                                        progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep))
                                                        self.stationService.get(source: .server, completion: { (entities) in
                                                            currentStep += 1
                                                            progress?(1, self.messageAtStep(currentStep))
                                                        })
                                                    })
                                                })
                                            })
                                        })
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
    
    func cachePrimed(completion: ((Bool) -> Void)?) {
        
        // Since primeCache loads all core data, we assume if there are species in the cache then the rest of the core data will be present too
//        speciesService.source = .cache
//        speciesService.get { (species, error) in
//            completion?(species.count != 0)
//        }
        completion?(false)
    }
    
}
