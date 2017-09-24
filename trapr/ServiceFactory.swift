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
            result = DataService().realmTestInstance
        } else {
            result = DataService().realm
        }
        return result!
    }()
    
    lazy var applicationService: ApplicationServiceInterface = {
        return ApplicationService(realm: self.realm)
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
    
}
