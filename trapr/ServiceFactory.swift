//
//  ServiceFactory.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
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
    
    lazy var cachePrimerFirestoreService: CachePrimerServiceInterface = {
        return CachePrimerFirestoreService()
    }()
    
    lazy var visitFirestoreService: VisitServiceInterface = {
        return VisitFirestoreService(firestore: self.firestoreDatabase, collectionName: "visits")
    }()
    
    lazy var visitSummaryFirestoreService: VisitSummaryServiceInterface = {
        return VisitSummaryFirebaseService(firestore: self.firestoreDatabase)
    }()
    
    lazy var traplineFirestoreService: TraplineServiceInterface = {
        return TraplineFirestoreService(firestore: self.firestoreDatabase, collectionName: "traplines")
    }()
    
    lazy var routeFirestoreService: RouteServiceInterface = {
        return RouteFirestoreService(firestore: self.firestoreDatabase, collectionName: "routes")
    }()
   
    lazy var routeUserSettingsFirestoreService: RouteUserSettingsServiceInterface = {
        return RouteUserSettingsFirestoreService(firestore: self.firestoreDatabase, collectionName: "routeUserSettings")
    }()
    
    lazy var speciesFirestoreService: LookupFirestoreService<Species> = {
        return SpeciesFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "species")
    }()

    lazy var trapTypeFirestoreService: LookupFirestoreService<TrapType> = {
        return TrapTypeFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "trapTypes")
    }()

    lazy var lureFirestoreService: LookupFirestoreService<Lure> = {
        return LureFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "lures")
    }()
    
    lazy var stationFirestoreService: StationServiceInterface = {
        return StationFirestoreService(firestore: self.firestoreDatabase, collectionName: "stations")
    }()
    
    lazy var htmlService: HtmlServiceInterface = {
        return HtmlService()
    }()
    
    lazy var regionFirestoreService: LookupFirestoreService<Region> = {
        return RegionFirestoreService(firestore: self.firestoreDatabase, lookupCollectionName: "region")
    }()
    
    lazy var userService: UserServiceInterface = {
        if runningInTestMode {
            return UserServiceTestMock()
        } else {
            return UserService(firestore: self.firestoreDatabase, collectionName: "users")
        }
    }()
    
    lazy var userSettingsService: UserSettingsServiceInterface = {
        return UserSettingsFirestoreService(firestore: self.firestoreDatabase, collectionName: "userSettings")
    }()
    
    lazy var excelService: ExcelServiceInterface = {
        return ExcelService()
    }()
}
