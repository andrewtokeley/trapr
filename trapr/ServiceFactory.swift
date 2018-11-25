//
//  ServiceFactory.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseFirestore

class ServiceFactory {
    
    static let sharedInstance = ServiceFactory()

    var runningInTestMode: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    lazy var firestoreDatabase: Firestore = {
        var result: Firestore
        if runningInTestMode {
            //result = Firestore.firestore(app: testApp)
            result = Firestore.firestore()
        } else {
            //result = Firestore.firestore(app: productionApp)
            result = Firestore.firestore()
        }
        return result
    }()
    
    lazy var realm: Realm = {
        var result: Realm?
        if runningInTestMode {
            result = DataService.sharedInstance.realmTestInstance
        } else {
            result = DataService.sharedInstance.realm
        }
        return result!
    }()
    
    lazy var dataPopulatorService: DataPopulatorServiceInterface = {
        return RealmDataPopulatorService(realm: self.realm)
    }()
    
    lazy var dataPopulatorFirestoreService: DataPopulatorServiceInterface = {
        return DataPopulatorFirestoreService(firestore: self.firestoreDatabase)
    }()
    
    lazy var visitService: VisitServiceInterface = {
        return VisitService(realm: self.realm)
    }()
    
    lazy var visitFirestoreService: VisitServiceInterface = {
        return VisitFirestoreService(firestore: self.firestoreDatabase, collectionName: "visits")
    }()
    
    lazy var visitSummaryFirestoreService: VisitSummaryServiceInterface = {
        return VisitSummaryFirebaseService(firestore: self.firestoreDatabase)
    }()
    
    lazy var traplineService: TraplineServiceInterface = {
        return TraplineService(realm: self.realm)
    }()
    
    lazy var traplineFirestoreService: TraplineServiceInterface = {
        return TraplineFirestoreService(firestore: self.firestoreDatabase, collectionName: "traplines")
    }()
    
    lazy var routeService: RouteServiceInterface = {
        return RouteService(realm: self.realm)
    }()
    
    lazy var routeFirestoreService: RouteServiceInterface = {
        return RouteFirestoreService(firestore: self.firestoreDatabase, collectionName: "routes")
    }()
    
    lazy var speciesService: LookupService<Species> = {
        return SpeciesService(realm: self.realm)
    }()
    
    lazy var speciesFirestoreService: LookupFirestoreService<_Species> = {
        return SpeciesFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "species")
    }()
    
    lazy var trapTypeService: LookupService<TrapType> = {
        return TrapTypeService(realm: self.realm)
    }()
    
    lazy var trapTypeFirestoreService: LookupFirestoreService<_TrapType> = {
        return TrapTypeFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "trapTypes")
    }()
    
    lazy var lureService: LookupService<Lure> = {
        return LureService(realm: self.realm)
    }()
    
    lazy var lureFirestoreService: LookupFirestoreService<_Lure> = {
        return LureFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "lures")
    }()
    
    lazy var stationService: StationServiceInterface = {
        return StationService(realm: self.realm)
    }()
    
    lazy var stationFirestoreService: StationServiceInterface = {
        return StationFirestoreService(firestore: self.firestoreDatabase, collectionName: "stations")
    }()
    
    lazy var settingsService: SettingsServiceInterface = {
        return SettingsService(realm: self.realm)
    }()
    
    lazy var trapService: TrapServiceInterface = {
        return TrapService(realm: self.realm)
    }()
    
    lazy var visitSyncService: VisitSyncServiceInterface = {
        return VisitSyncService(realm: self.realm)
    }()
    
    lazy var htmlService: HtmlServiceInterface = {
        return HtmlService()
    }()
    
    lazy var savedImageService: SavedImageServiceInterface = {
        return SavedImageService(realm: self.realm)
    }()
    
    lazy var regionService: RegionServiceInterface = {
        return RegionService(realm: self.realm)
    }()
    
    lazy var regionFirestoreService: LookupFirestoreService<_Region> = {
        return RegionFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "region")
    }()
    
    lazy var userService: UserServiceInterface = {
        // TODO - toggle to test/prod FireStore
        return UserService(firestore: self.firestoreDatabase, collectionName: "users")
    }()
}
