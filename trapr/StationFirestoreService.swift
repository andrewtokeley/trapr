//
//  StationFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 4/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate struct LureTotals {
    var added: Int = 0
    var removed: Int = 0
    var eaten: Int = 0
}

class StationFirestoreService: FirestoreEntityService<Station> {
    private lazy var trapTypeService = { ServiceFactory.sharedInstance.trapTypeFirestoreService }()
    private lazy var traplineService = { ServiceFactory.sharedInstance.traplineFirestoreService }()
    private lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    private lazy var routeService = { ServiceFactory.sharedInstance.routeFirestoreService }()
}

extension StationFirestoreService: StationServiceInterface {
    
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?) {
        
        var totals = LureTotals()
        
        // get all the visits for the trap, ever - super inefficient!
        visitService.get(recordedBetween: Date().add(0,0,-100), dateEnd: asAtDate.dayEnd(), stationId: stationId, trapTypeId: trapTypeId) { (visits, error) in
            
            // total up how many added, eaten, removed
            for visit in visits {
                totals.added += visit.baitAdded
                totals.removed += visit.baitRemoved
                totals.eaten += visit.baitEaten
            }
            let balance = totals.added - (totals.eaten + totals.removed)
            completion?(balance)
        }
    }
    
    func updateActiveState(station: Station, trapTypeId: String, active: Bool, completion: ((Station?, Error?) -> Void)?) {
        
        var trapTypeStatus = station.trapTypes.filter({ $0.trapTpyeId == trapTypeId }).first
        
        if trapTypeStatus != nil {
            trapTypeStatus?.active = active
            self.add(station: station, completion: { (updatedStation, error) in
                completion?(updatedStation, error)
            })
        } else {
            completion?(station, nil)
        }
    }
    
    func addTrapTypeToStation(station: Station, trapTypeId: String, completion:  (([Station], Error?) -> Void)?) {
    
        
    }
    
    func removeTrapType(station: Station, trapTypeId: String, completion: ((Station?, Error?) -> Void)?) {
        // TODO: do I need to do this? Or can I change station directly?
        let stationRef = station
        stationRef.trapTypes.removeAll { $0.trapTpyeId == trapTypeId }
        self.add(station: stationRef, completion: { (station, error) in
            completion?(station, error)
        })
    }
    
    func add(station: Station, completion: ((Station?, Error?) -> Void)?) {
        let _ = super.add(entity: station) { (station, error) in
            completion?(station, error)
        }
    }

    func add(stations: [Station], completion: (([Station], Error?) -> Void)?) {
        super.add(entities: stations) { (stations, error) in
            completion?(stations, error)
        }
    }

    func associateStationWithTrapline(stationId: String, traplineId: String, completion: ((Error?) -> Void)?) {
        self.get(id: stationId) { (station, error) in
            if let updateStation = station {
                updateStation.traplineId = traplineId
                self.update(entity: updateStation, completion: { (error) in
                    completion?(error)
                })
            } else {
                completion?(error)
            }
        }
    }
    
//    func insertStationToRoute(stationId: String, routeId: String, at index: Int, completion: ((Error?) -> Void)?) {
//        
//        var order: Int = 0
//        
//        // get all the stations on the route
//        self.get(routeId: routeId) { (stations) in
//            if index >= stations.count {
//                // we want the order to make the station appear last.
//                order = stations.count + 1
//            } else {
//                
//            }
//        }
//        self.get(id: stationId) { (station, error) in
//            if let station = station {
//                station.routeId = routeId
//                //station.visitOrder = index
//                self.update(entity: station, completion: { (error) in
//                    completion?(error)
//                })
//            }
//        }
//    }
//    
//    func addStationToRoute(routeId: String, stationId: String, completion: ((Error?) -> Void)?) {
//        self.get(id: stationId) { (station, error) in
//            if let station = station {
//                station.routeId = routeId
//                //station.visitOrder = index
//                self.update(entity: station, completion: { (error) in
//                    completion?(error)
//                })
//            }
//        }
//    }
//    func removeStationFromRoute(routeId: String, stationId: String, completion: ((Error?) -> Void)?) {
//        
//    }
//    func updateStationsOnRoute(routeId: String, stationIds: [String], completion: ((Error?) -> Void)?){
//    }
//    func replaceStationsOnRoute(routeId: String, withStations stationIds: [String], completion: (([Station], Error?) -> Void)?) {
//        
//    }
//    func reorderStations(routeId: String, stationOrder: [String: Int], completion: (([Station], Error?) -> Void)?) {
//        
//    }
    
    func delete(stationId: String, completion: ((Error?) -> Void)?) {
        super.delete(entityId: stationId) { (error) in
            completion?(error)
        }
    }
    
    func delete(stationIds: [String], completion: ((Error?) -> Void)?) {
        
        let batch = firestore.batch()
        
        for id in stationIds {
            super.delete(entityId: id, batch: batch)
        }
        
        batch.commit { (error) in
            completion?(error)
        }
    }

    func deleteAll(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities { (error) in
            completion?(error)
        }
    }
    
    func searchStations(searchTerm: String, regionId: String, completion: (([Station]) -> Void)?) {
        self.collection.whereField(StationFields.region.rawValue, isEqualTo: regionId).whereField(StationFields.traplineId.rawValue, isEqualTo:searchTerm).getDocuments { (snapshot, error) in
            
            completion?(super.getEntitiesFromQuerySnapshot(snapshot: snapshot))
        }
    }
    
    func get(stationId: String, completion: ((Station?, Error?) -> Void)?) {
        super.get(id: stationId) { (station, error) in
            completion?(station, error)
        }
    }
    
    func get(stationIds: [String], completion: (([Station], Error?) -> Void)?) {
        super.get(ids: stationIds) { (stations, error) in
            completion?(stations, error)
        }
    }
    
    func get(source: FirestoreSource, completion: (([Station]) -> Void)?) {
        super.get(source: source, limit: 1000) { (stations, error) in
            completion?(stations)
        }
    }
    
    
    func get(completion: (([Station]) -> Void)?) {
        super.get(orderByField: StationFields.number.rawValue) { (stations, error) in
            completion?(stations)
        }
    }
    
    func get(regionId: String, completion: (([Station]) -> Void)?) {
        super.get(whereField: StationFields.region.rawValue, isEqualTo: regionId) { (stations, error) in
            //TODO: completion?(stations, error)
            completion?(stations)
        }
    }
    
    func get(routeId: String, completion: (([Station]) -> Void)?) {

        routeService.get(routeId: routeId) { (route, error) in
            if let route = route {
                self.get(stationIds: route.stationIds) { (stations, error) in
                    for station in stations {
                        station.routeId = routeId
                    }
                    completion?(stations)
                }
            } else {
                completion?([Station]())
            }
        }
//        super.get(whereField: StationFields.route.rawValue, isEqualTo: routeId) { (stations, error) in
//            //TODO: completion?(stations, error)
//            completion?(stations)
//        }
    }
    
    func get(traplineId: String, completion: (([Station]) -> Void)?) {
        super.get(whereField: StationFields.traplineId.rawValue, isEqualTo: traplineId) { (stations, error) in
            let ordered = stations.sorted(by: { $0.number < $1.number })
            completion?(ordered)
        }
    }
    
//    func describe(stationIds: [String], includeStationCodes: Bool, completion: ((String) -> Void)?) {
//
//        let traplines = getTraplines(from: stations)
//
//        if !includeStationCodes {
//            // e.g. LW, E
//            return traplinesDescription(for: traplines)
//        } else {
//            var description = ""
//
//            for trapline in traplines {
//
//                // e.g.
//                // LW 1-10, 20-30
//                // E 1-5
//                let stationsInTrapline = self.stationsInTrapline(stations: stations, trapline: trapline)
//                let rangeDescriptions = stationsRangeDescriptions(for: stationsInTrapline)
//
//                for range in rangeDescriptions {
//                    description.append(trapline.code!)
//                    description.append(range)
//                    if (rangeDescriptions.last != range) {
//                        description.append(", ")
//                    }
//                }
//
//                // add comma unless it's the last trapline
//                if trapline != traplines.last {
//                    description.append(", ")
//                }
//            }
//            return description
//        }
//    }
    
    func reverseOrder(stations: [Station]) -> [Station] {
        var reordered = [Station]()
        for i in stride(from: stations.count - 1, through: 0, by: -1) {
            reordered.append(stations[i])
        }
        return reordered
    }

    /** DEPRACTED
     */
    func isStationCentral(station: Station, completion: ((Bool) -> Void)?) {
        completion?(false)
    }
    
    func getStationSequence(fromStationId: String, toStationId: String,  completion: (([Station], Error?) -> Void)?) {
        
        // get all the stations on the trapline
        self.get(stationId: fromStationId) { (station, error) in
            if let traplineId = station?.traplineId {
                
                self.get(traplineId: traplineId) { (stations) in
                    
                    if stations.filter({ $0.id == fromStationId || $0.id == toStationId }).count != 2 {
                        // stations not on the same trapline
                        completion?([Station](), nil)
                    } else {
                    
                        var sequence = [Station]()
                        if let fromIndex = stations.firstIndex (where: { $0.id == fromStationId } ), let toIndex = stations.firstIndex (where: { $0.id == toStationId } ) {
                            var index = fromIndex
                            for i in 0...abs(fromIndex-toIndex) {
                                index = fromIndex + i * (fromIndex < toIndex ? 1 : -1)
                                sequence.append(stations[index])
                            }
                        }
                    
                        completion?(sequence, nil)
                    }
                }
            }
        }
    }
    
    func getActiveOrHistoricTraps(route: Route, station: Station, date: Date, completion: (([TrapType]) -> Void)?) {
        
        // get the active traptypes from the station
        let trapTypesStatus = station.trapTypes.filter { (status) -> Bool in
            return status.active
        }
        
        // need to add any inactive traps that have a visit recorded against them on the given date
        // TODO
        let codes = trapTypesStatus.map { $0.trapTpyeId }
        
        self.trapTypeService.get(ids: codes) { (trapTypes, error) in
            completion?(trapTypes.sorted(by: { $0.order < $1.order }))
        }
    }
    
    
    func getMissingStationIds(completion: (([String]) -> Void)?) {

        var missingStationIds = [String]()
        
        self.traplineService.get { (traplines) in
            let dispatchGroup = DispatchGroup()
            for trapline in traplines {
                dispatchGroup.enter()
                self.getMissingStationIds(trapline: trapline, completion: { (missingIds) in
                    missingStationIds += missingIds
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main) {
                completion?(missingStationIds)
            }
        }
        
    }

    func getMissingStationIds(trapline: Trapline, completion: (([String]) -> Void)?) {
    
        var missingStations = [String]()
        
        // get all the stations for the trapline
        self.get(traplineId: trapline.id!) { (stations) in
            
            let traplineId = trapline.id!
            
            let stationsOnTrapline = stations.filter({ (station) -> Bool in
                station.traplineId == traplineId
            }).sorted(by: { $0.number < $1.number })
                
            if stationsOnTrapline.count > 0 {
                    
                let firstStationCode = stationsOnTrapline.first!.number
                let lastStationCode = stationsOnTrapline.last!.number
                
                // we expect to find all the stations between these codes
                for number in firstStationCode...lastStationCode {
                    
                    // record if we can't find a station with a given code
                    if stationsOnTrapline.first(where: {$0.number == number}) == nil {
                        missingStations.append("\(stationsOnTrapline.first!.traplineCode ?? "--")\(String(format: "%02d", number))")
                    }
                }
            }
            completion?(missingStations)
        }
    }
    
//    private func getStationsFromSnapshot(snapshot: QuerySnapshot?) -> [Station]? {
//
//        var results = [Station]()
//
//        if let documents = snapshot?.documents {
//            for document in  documents {
//                if let result = Station(dictionary: document.data()) {
//                    result.id = document.documentID
//                    results.append(result)
//                }
//            }
//        }
//        return results.count > 0 ? results : nil
//    }
    
//    func reverseOrder(stations: [Station]) -> [Station] {
//        var reordered = [Station]()
//        for i in stride(from: stations.count - 1, through: 0, by: -1) {
//            reordered.append(stations[i])
//        }
//        return reordered
//    }
    
//    private func getTraplines(from stations: [Station]) -> [Trapline] {
//
//        var traplines = [Trapline]()
//
//        for station in stations {
//            if let trapline = station.trapTypes {
//                if traplines.filter({ $0.code == trapline.code }).isEmpty {
//                    traplines.append(trapline)
//                }
//            }
//        }
//
//        return traplines
//    }
    
    func trapTypeCounts(stations: [Station]) -> [String: Int] {
        var counts = [String: Int]()
        counts["sfds"] = 2
        return counts
    }
    
    func description(stationIds: [String], completion: ((String?, String?, Error?) -> Void)?) {
        self.get(ids: stationIds) { (stations, error) in
            if let error = error {
                completion?(nil, nil, error)
            } else {
                let descriptionWithCodes = self.description(stations: stations, includeStationCodes: true)
                let descriptionWithoutCodes = self.description(stations: stations, includeStationCodes: false)
                
                completion?(descriptionWithCodes, descriptionWithoutCodes, nil)
            }
        }
    }
    
    func description(stations: [Station], includeStationCodes: Bool) -> String {
        
        let traplineCodes = traplineService.extractTraplineCodesFromStations(stations: stations)
        let traplineIds = traplineService.extractTraplineReferencesFromStations(stations: stations)
        
        let traplinesDict = Dictionary(uniqueKeysWithValues: zip(traplineIds, traplineCodes))
    
        if !includeStationCodes {
            // e.g. LW, E
            return traplineCodes.joined(separator: ", ")
            
        } else {
            
            var traplineDescriptions = [String]()
            
            for trapline in traplinesDict {
                
                let stationsInTrapline = stations.filter { $0.traplineId == trapline.key }.sorted(by: { $0.longCode < $1.longCode })
                
                // ["1-10", "20-30"]
                var rangeDescriptions = stationsRangeDescriptions(for: stationsInTrapline)
                
                // ["LW1-10", "LW20-30"]
                rangeDescriptions = rangeDescriptions.map{ trapline.value + $0 }
                
                traplineDescriptions.append(rangeDescriptions.joined(separator: ", "))
                
            }
            // N05, LW01-10
            return traplineDescriptions.joined(separator: ", ")
        }
    }
    
    private func stationsRangeDescriptions(for stations: [Station]) -> [String] {
        
        var ranges = [String]()
        var lowRange: String?
        
        for count in 0...stations.count {
            
            if count == 0 {
                lowRange = stations[count].codeFormated
            } else {
                
                // will be nil when we're on the considering the last station's range
                let station = count < stations.count ? stations[count] : nil
                
                let previousCodeValue = Int(stations[count - 1].codeFormated) ?? 0
                
                // 1000 is assumed to NOT be the next/previous in a sequence, so will for a new range to start
                let thisCodeValue = station != nil ? Int(station!.codeFormated) : 1000
                
                // if this code isn't part of a sequence
                if abs(thisCodeValue! - previousCodeValue) != 1 {
                    
                    // finish the last range
                    if lowRange == stations[count - 1].codeFormated {
                        ranges.append(lowRange!)
                    } else {
                        ranges.append("\(lowRange!)-\(stations[count - 1].codeFormated)")
                    }
                    
                    // this is the beginning of a new range, so reset the lowRange
                    lowRange = station?.codeFormated
                }
            }
        }
        
        return ranges
    }
}

