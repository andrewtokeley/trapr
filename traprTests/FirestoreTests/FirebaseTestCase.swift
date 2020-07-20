//
//  FirebaseTestCase.swift
//  traprTests
//
//  Created by Andrew Tokeley on 13/02/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import trapr_development

class FirebaseTestCase: XCTestCase {

    private var regionService = ServiceFactory.sharedInstance.regionFirestoreService
    private var routeService = ServiceFactory.sharedInstance.routeFirestoreService
    private var stationService = ServiceFactory.sharedInstance.stationFirestoreService
    private var traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    private var visitService = ServiceFactory.sharedInstance.visitFirestoreService
    
    var TESTPREFIX = "_test_"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Remove any TESTPREFIX codes in a string
    func cleanTestString(_ testString: String) -> String {
        var rawId = testString
        var range = rawId.range(of: TESTPREFIX)
        while range != nil {
            rawId.replaceSubrange(range!, with: "")
            range = rawId.range(of: TESTPREFIX)
        }
        return rawId
    }
    
    /// Converts a test route name, that will be the format _test_ROUTENAME to ROUTENAME
    func createTestRoute(name: String, stationIds: [String] = [String](), completion: ((Route?) -> Void)?) {
        if let route = try? Route(name: "\(TESTPREFIX)name", stationIds: [String]()) {
            for stationId in stationIds {
                route.stationIds.append(stationId)
            }
            let _ = routeService.add(route: route) { (route, error) in
                completion?(route)
            }
        } else {
            completion?(nil)
        }
    }
    
    /// Creates a test trapline and optionally stations. Each station will be given a pellibat, doc200 and possumMast trap. If you want to control the traptypes then set the numberOfStations to 0 and use the createTestStations() func
    func createTestTrapline(regionId: String, traplineCode: String, numberOfStations: Int = 1, completion: ((Trapline?, [Station]) -> Void)?) {
        
        let trapTypes = [TrapTypeStatus(trapTpyeId: TrapTypeCode.pellibait.rawValue, active: true),
                         TrapTypeStatus(trapTpyeId: TrapTypeCode.doc200.rawValue, active: true),
                         TrapTypeStatus(trapTpyeId: TrapTypeCode.possumMaster.rawValue, active: true)
                        ]
        let testRegionId = "\(TESTPREFIX)\(regionId)"
        var stations = [Station]()
        let region = Region(id: testRegionId, name: "\(TESTPREFIX)TestRegion", order: 0)
        self.regionService.add(lookup: region) { (error) in
            let trapline = Trapline(code: "\(self.TESTPREFIX)\(traplineCode)", regionCode: testRegionId, details: "")
            let _ = self.traplineService.add(trapline: trapline) { (trapline, error) in
                if numberOfStations > 0 {
                    let dispatchGroup = DispatchGroup()
                    for i in 1...numberOfStations {
                        dispatchGroup.enter()
                        self.createTestStation(trapline: trapline!, stationNumber: i, trapTypes: trapTypes) { (station) in
                            stations.append(station)
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        completion?(trapline, stations)
                    })
                } else {
                    completion?(trapline, stations)
                }
            }
        }
    }
    
    func createTestStation(trapline: Trapline, stationNumber: Int, trapTypes: [TrapTypeStatus] = [TrapTypeStatus](), completion: ((Station) -> Void)?) {
        if let traplineid = trapline.id {
            let station = Station(traplineId: traplineid, number: stationNumber)
            station.traplineCode = trapline.code
            for trapType in trapTypes {
                station.trapTypes.append(trapType)
            }
            self.stationService.add(station: station) { (station, error) in
                if let station = station {
                    completion?(station)
                }
            }
        }
    }
    
    func createTestVisit(_ date: Date, _ baitAdded: Int = 0, _ baitEaten: Int = 0, _ baitRemoved: Int = 0, _ routeId: String, _ traplineId: String, _ stationId: String, _ trapTypeCode: TrapTypeCode, _ trapSetStatus: TrapSetStatus? = nil, _ speciesCode: SpeciesCode? = nil, completion: (() -> Void)? = nil) {
        
        let visit = Visit(date: date, routeId: routeId, traplineId: traplineId, stationId: stationId, trapTypeId: trapTypeCode.rawValue)
        
        visit.trapSetStatusId = trapSetStatus?.rawValue
        visit.baitEaten = baitEaten
        visit.baitRemoved = baitRemoved
        visit.baitAdded = baitAdded
        visit.speciesId = speciesCode?.rawValue
        
        self.visitService.add(visit: visit) { (visit, error) in
            completion?()
        }
    }
    
    func deleteTestTraplines(completion: (() -> Void)?) {
        
        var traplinesToDelete = [String]()
        traplineService.get { (traplines) in
            if traplines.count > 0 {
                for trapline in traplines {
                    if trapline.code.starts(with: "\(self.TESTPREFIX)") {
                        if let id = trapline.id {
                            traplinesToDelete.append(id)
                        }
                    }
                }
                self.traplineService.delete(traplineIds: traplinesToDelete, completion: { (error) in
                    completion?()
                })
            } else {
                completion?()
            }
        }
    }
    
    /// Delete all the stations that are tests ones. i.e. start with the test prefix
    func deleteTestStations(completion: (() -> Void)?) {
        var stationsToDelete = [String]()
        stationService.get { (stations) in
            if stations.count > 0 {
                for station in stations {
                    if let id = station.id {
                        if id.starts(with: "\(self.TESTPREFIX)") {
                            stationsToDelete.append(id)
                        }
                    }
                }
                self.stationService.delete(stationIds: stationsToDelete) { (error) in
                    completion?()
                }
            } else {
                completion?()
            }
        }
    }

    func deleteTestVisits(completion: (() -> Void)?) {
        
        // delete all the visits on routes owned by tester@andrewtokeley.com
        visitService.deleteAll { (error) in
            completion?()
        }
    }
    
    func deleteTestRoutes(completion: (() -> Void)?) {
        
        // delete all the routes tester@andrewtokeley.com has access to
        routeService.delete { (error) in
            completion?()
        }
    }
}
