//
//  StationService.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class StationService: RealmService, StationServiceInterface {
    
    // MARK: - StationServiceInterface
    
    // Not implemented in Realm
    func add(station: _Station, completion: ((_Station?, Error?) -> Void)?) {}
    func add(stations: [_Station], completion: (([_Station], Error?) -> Void)?) {}
    func associateStationWithTrapline(stationId: String, traplineId: String, completion: ((Error?) -> Void)?) {}
    func delete(stationId: String, completion: ((Error?) -> Void)?) {}
    func deleteAll(completion: ((Error?) -> Void)?) {}
    func searchStations(searchTerm: String, regionId: String, completion: (([_Station]) -> Void)?) {}
    func get(completion: (([_Station]) -> Void)?) {}
    func get(regionId: String, completion: (([_Station]) -> Void)?) {}
    func get(traplineId: String, completion: (([_Station]) -> Void)?) {}
    func get(routeId: String, completion: (([_Station]) -> Void)?) {}
    func describe(stations: [_Station], includeStationCodes: Bool, completion: ((String) -> Void)?) {}
    func reverseOrder(stations: [_Station]) -> [_Station] { return [_Station]()}
    func isStationCentral(station: _Station, completion: ((Bool) -> Void)?) {}
    func getStationSequence(_ from: _Station, _ to:_Station,  completion: (([_Station]?) -> Void)?) {}
    func getTraplines(from stations: [_Station], completion: (([_Trapline]?) -> Void)?) {}
    func getActiveOrHistoricTraps(route: _Route, station: _Station, date: Date, completion: (([_TrapType]?) -> Void)?) {}
    func getMissingStations(completion: (([String]) -> Void)?) {}
    func getDescription(stations: [_Station], includeStationCodes: Bool) -> String { return "" }
    
    func delete(station: Station) {
        try! realm.write {
            realm.delete(station)
        }
    }
    
    func searchStations(searchTerm: String, region: Region?) -> [Station] {
        return Array(realm.objects(Station.self).filter({ $0.longCode.uppercased().contains(searchTerm.uppercased())}).filter({ $0.trapline?.region == region }))
    }
    
    func getActiveOrHistoricTraps(route: Route, station: Station, date: Date) -> [Trap] {
        var traps = [Trap]()
        
        for trap in station.traps {
            if !trap.archive {
                traps.append(trap)
            } else {
                // only add if there are visits for the trap on this day
                if let visit = ServiceFactory.sharedInstance.visitService.getVisits(recordedBetween: date.dayStart(), dateEnd: date.dayEnd(), route: route, trap: trap) {
                    if visit.count != 0 {
                        traps.append(trap)
                    }
                }
            }
        }
        
        return traps.sorted(by: { $0.type?.order ?? 0 < $1.type?.order ?? 1 }, stable: true)
    }
    
    func getAll() -> [Station] {
        return Array(realm.objects(Station.self))
    }
    
    func getAll(region: Region?) -> [Station] {
        return Array(realm.objects(Station.self).filter({ $0.trapline?.region == region }))
    }
    
    func getMissingStations() -> [String] {
        var missingStations = [String]()
        let traplines = getTraplines(from: getAll())
        for trapline in traplines {
            let stations = Array(trapline.stations).sorted(by: { ($0.codeAsNumber ?? 0) < ($1.codeAsNumber ?? 0) }, stable: true)
            if stations.count > 0 {
                if let firstStationCode = Int(stations.first!.code!), let lastStationCode = Int(stations.last!.code!) {
                    
                    // we expect to find all the stations between these codes
                    for code in firstStationCode...lastStationCode {
                        if stations.first(where: {Int($0.code!) == code}) == nil {
                            missingStations.append(trapline.code! + String(format: "%02d", code))
                        }
                    }
                }
            }
        }
        return missingStations
        
    }
    
    
    
    func getStationSequence(_ from: Station, _ to:Station) -> [Station]? {
        guard from.trapline != nil && to.trapline != nil else { return nil }
        
        // are the stations on the same line?
        if from.trapline == to.trapline {
            let stations = Array(from.trapline!.stations)
            if let fromIndex = stations.index(of: from), let toIndex = stations.index(of: to) {
                
                var sequence = [Station]()
                var index = fromIndex
                for i in 0...abs(fromIndex-toIndex) {
                    index = fromIndex + i * (fromIndex < toIndex ? 1 : -1)
                    sequence.append(stations[index])
                }
                
                return sequence
            }
        }
        return nil
    }
    
    func isStationCentral(station: Station) -> Bool {
        if let stationsOnTrapline = station.trapline?.stations {
            
            if stationsOnTrapline.count == 1 {
                return true
            } else {
                if let position = stationsOnTrapline.index(of: station) {
                    // subtract to get into 0 based array comparison
                    let centralPosition = Int(Double(stationsOnTrapline.count) / 2.0) - 1
                    return position == centralPosition
                }
            }
        }
        return false
    }
    
    func reverseOrder(stations: [Station]) -> [Station] {
        var reordered = [Station]()
        for i in stride(from: stations.count - 1, through: 0, by: -1) {
            reordered.append(stations[i])
        }
        return reordered
    }
    
    func getTraplines(from stations: [Station]) -> [Trapline] {
        
        var traplines = [Trapline]()
        
        for station in stations {
            if let trapline = station.trapline {
                if traplines.filter({ $0.code == trapline.code }).isEmpty {
                    traplines.append(trapline)
                }
            }
        }
        
        return traplines
    }
    
    func getDescription(stations: [Station], includeStationCodes: Bool) -> String {
        
        let traplines = getTraplines(from: stations)
        
        if !includeStationCodes {
            // e.g. LW, E
            return traplinesDescription(for: traplines)
        } else {
            var description = ""
            
            for trapline in traplines {
                
                // e.g.
                // LW 1-10, 20-30
                // E 1-5
                let stationsInTrapline = self.stationsInTrapline(stations: stations, trapline: trapline)
                let rangeDescriptions = stationsRangeDescriptions(for: stationsInTrapline)
                
                for range in rangeDescriptions {
                    description.append(trapline.code!)
                    description.append(range)
                    if (rangeDescriptions.last != range) {
                        description.append(", ")
                    }
                }
                
                // add comma unless it's the last trapline
                if trapline != traplines.last {
                    description.append(", ")
                }
            }
            return description
        }
    }
    
    private func traplinesDescription(for traplines: [Trapline]) -> String {
        
        var description = ""
        
        for trapline in traplines {
            if let code = trapline.code {
                description.append(code)
                if trapline != traplines.last {
                    description.append(", ")
                }
            }
        }
        
        return description
    }
    
    private func stationsInTrapline(stations: [Station], trapline: Trapline) -> [Station] {
        let filteredStations = stations.filter({
            station in
            return station.trapline! == trapline
        })
        
        return filteredStations
    }
    
    private func stationsRangeDescriptions(for stations: [Station]) -> [String] {
        
        var ranges = [String]()
        var lowRange: String?
        
        for count in 0...stations.count {
            
            if count == 0 {
                lowRange = stations[count].code!
            } else {
                
                // will be nil when we're on the considering the last station's range
                let station = count < stations.count ? stations[count] : nil
                
                let previousCodeValue = Int(stations[count - 1].code!) ?? 0

                // 1000 is assumed to NOT be the next/previous in a sequence, so will for a new range to start
                let thisCodeValue = station != nil ? Int(station!.code!) : 1000
                
                // if this code isn't part of a sequence
                if abs(thisCodeValue! - previousCodeValue) != 1 {
                    
                    // finish the last range
                    if lowRange == stations[count - 1].code! {
                        ranges.append(lowRange!)
                    } else {
                        ranges.append("\(lowRange!)-\(stations[count - 1].code!)")
                    }
                    
                    // this is the beginning of a new range, so reset the lowRange
                    lowRange = station?.code!
                }
            }
        }
        
        return ranges
    }
    
}
