//
//  StationService.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class StationService: RealmService, StationServiceInterface {
    
    func getAll() -> [Station] {
        return Array(realm.objects(Station.self))
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
