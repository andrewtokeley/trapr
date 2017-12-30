//
//  ServiceFactory.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class ServiceFactory {
    
    static let sharedInstance = ServiceFactory()
    
    lazy var realm: Realm = {
        var result: Realm?
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            result = DataService.sharedInstance.realmTestInstance
        } else {
            result = DataService.sharedInstance.realm
        }
        return result!
    }()
    
    lazy var dataPopulatorService: DataPopulatorServiceInterface = {
        return DataPopulatorService(realm: self.realm)
    }()
    
    lazy var visitService: VisitServiceInterface = {
        return VisitService(realm: self.realm)
    }()
    
    lazy var traplineService: TraplineServiceInterface = {
        return TraplineService(realm: self.realm)
    }()
    
    lazy var routeService: RouteServiceInterface = {
        return RouteService(realm: self.realm)
    }()
    
    lazy var speciesService: LookupService<Species> = {
        return SpeciesService(realm: self.realm)
    }()
    
    lazy var trapTypeService: LookupService<TrapType> = {
        return TrapTypeService(realm: self.realm)
    }()
    
    lazy var lureService: LookupService<Lure> = {
        return LureService(realm: self.realm)
    }()
    
    lazy var stationService: StationServiceInterface = {
        return StationService(realm: self.realm)
    }()
    
    lazy var settingsService: SettingsServiceInterface = {
        return SettingsService(realm: self.realm)
    }()
    
    lazy var trapService: TrapServiceInterface = {
        return TrapService(realm: self.realm)
    }()
    
    lazy var htmlService: HtmlServiceInterface = {
        return HtmlService()
    }()
    
}
