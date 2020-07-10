//
//  CachePrimerFirestoreService.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 20/12/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class CachePrimerFirestoreService {
    fileprivate lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    fileprivate lazy var speciesService = { ServiceFactory.sharedInstance.speciesFirestoreService }()
    fileprivate lazy var userService = { ServiceFactory.sharedInstance.userService }()
    fileprivate lazy var trapTypeService = { ServiceFactory.sharedInstance.trapTypeFirestoreService }()
    fileprivate lazy var lureService = { ServiceFactory.sharedInstance.lureFirestoreService }()
    fileprivate lazy var traplineService = { ServiceFactory.sharedInstance.traplineFirestoreService }()
    fileprivate lazy var stationService = { ServiceFactory.sharedInstance.stationFirestoreService }()
    fileprivate lazy var regionService = { ServiceFactory.sharedInstance.regionFirestoreService }()
    fileprivate lazy var routeService = { ServiceFactory.sharedInstance.routeFirestoreService }()
    fileprivate lazy var routeUserSettingsService = { ServiceFactory.sharedInstance.routeUserSettingsFirestoreService }()
    
    // there are 11 server actions to prime the cache
    // Get Visits, Routes, Regions, Traplines, Stations, Create DefaultLookup Values (3), Lookups (3)
    // If you don't update this number things will still work but the percentage complete will not look right
    fileprivate let NUMBER_OF_STEPS = 12
    
    // If, the number of steps exceeds the number of loadingMessages, we'll use the message at this index
    fileprivate let DEFAULT_MESSAGE_INDEX = 6
    
    // Messages that will be displayed randomly
    fileprivate var loadingMessages = [
        "random act of kindness",
        "did you remember to bring a screwdriver?",
        "tick, tock...",
        "less possums, more trees!",
        "getting closer...",
        "nothing to see here",
        "almost there, promise"
    ]

    fileprivate func progressAtStep(_ step: Int) -> Double {
        if step < NUMBER_OF_STEPS {
            return Double(step)/Double(NUMBER_OF_STEPS)
        } else {
            return 1
        }
    }
    
    fileprivate func messageAtStep(_ step: Int) -> String {
        // show in-progress messages
        if step < loadingMessages.count - 1 {
            return loadingMessages[step]
        // show default message if
        } else {
            return loadingMessages[DEFAULT_MESSAGE_INDEX]
        }
    }
    
}

extension CachePrimerFirestoreService: CachePrimerServiceInterface {
    
    func primeCache(progress: ((Double, String, Bool) -> Void)?) {
        
        loadingMessages.shuffle()
        
        var currentStep = 0
        progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
    
        // force reading data from the server
        self.visitService.get(source: .server, completion: { (entities) in
            currentStep += 1
            progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
            self.routeService.get(source: .server, includeHidden: true, completion: { (entities, error) in
                currentStep += 1
                progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                self.speciesService.createOrUpdateDefaults(completion: {
                    currentStep += 1
                    progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                    self.speciesService.get(source: .server, completion: { (entities, error) in
                        currentStep += 1
                        progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                        self.lureService.createOrUpdateDefaults(completion: {
                            currentStep += 1
                            progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                            self.lureService.get(source: .server, completion: { (entities, error) in
                                currentStep += 1
                                progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                                self.trapTypeService.createOrUpdateDefaults(completion: {
                                    currentStep += 1
                                    progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                                    self.trapTypeService.get(source: .server, completion: { (entities, error) in
                                        currentStep += 1
                                        progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                                        self.regionService.get(source: .server, completion: { (entities, error) in
                                            currentStep += 1
                                            progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                                            
                                            self.traplineService.get(source: .server, completion: { (entities) in
                                                currentStep += 1
                                                progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                                                self.stationService.get(source: .server, completion: { (entities) in
                                                    currentStep += 1
                                                    progress?(self.progressAtStep(currentStep), self.messageAtStep(currentStep), false)
                                                        self.routeUserSettingsService.get(source: .server, completion: { (entities, error) in
                                                            print(entities.count)
                                                        
                                                            currentStep += 1
                                                            progress?(1, "Done!", true)
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
        })
    }
    
    func cachePrimed(completion: ((Bool) -> Void)?) {
        
        // Since primeCache loads all core data, we assume if there are species in the cache then the rest of the core data will be present too
        speciesService.get(source: .cache) { (species, error) in
            completion?(species.count != 0)
        }
    }
    
}
