//
//  Route.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum TimePeriod: Int {
    case week = 0
    case fortnight = 1
    case month = 2
    case twoMonths = 3
    case sixMonths = 4
    
    var name: String {
        switch self {
        case .week: return "Weekly"
        case .fortnight: return "Fornightly"
        case .month: return "Monthly"
        case .twoMonths: return "Every 2 months"
        case .sixMonths: return "Every 6 months"
        }
    }
    
    static var count: Int {
        return TimePeriod.all.count
    }
    
    static var all: [TimePeriod] {
        return [.week, .fortnight, .month, .twoMonths, sixMonths]
    }
    
    static var defaultValue: TimePeriod {
        return TimePeriod.month
    }
}

class Route: Object {
    
    //MARK: - Persisted Properties
    
    dynamic var id: String = UUID().uuidString
    let stations = List<Station>()
    dynamic var name: String?
    dynamic var visitFrequencyRaw: Int = 0
    
    
    //MARK: - Read-Only Properties
    
    var traplines: List<Trapline> {
        return self.getTraplines(from: self.stations)
    }
    
    var visitFrequency: TimePeriod {
        return TimePeriod(rawValue: visitFrequencyRaw) ?? .month
    }
    
    var shortDescription: String {
        return getDescription(includeStationCodes: false)
    }
    
    var longDescription: String {
        return getDescription(includeStationCodes: true)
    }
    
    
    //MARK: - Object overrides
    
    override static func ignoredProperties() -> [String] {
        // have to explicitly ignore lazy properties
        return ["traplines"]
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    //MARK: - Initialisation
    
    convenience init(name: String, stations: [Station]) {
        self.init()
        self.stations.append(objectsIn: stations)
        self.name = name
    }
    
    convenience init(name: String, visits: [Visit]) {

        var stations = [Station]()
        
        // get the stations from the visits
        for visit in visits {
            if let station = visit.trap?.station {
                if !stations.contains(where: { $0.longCode == station.longCode} ) {
                    stations.append(station)
                }
            }
        }
        self.init(name: name, stations: stations)
    }
    
    
    //MARK: - Private functions
    
    private func getDescription(includeStationCodes: Bool) -> String {
        
        if !includeStationCodes {
            // e.g. LW, E
            return traplinesDescription(for: self.traplines)
        } else {
            var description = ""
            
            for trapline in self.traplines {
                
                // e.g.
                // LW 1-10, 20-30
                // E 1-5
                let rangeDescriptions = stationsRangeDescriptions(for: trapline)
                for range in rangeDescriptions {
                    description.append(trapline.code!)
                    description.append(range)
                    if (rangeDescriptions.last != range) {
                        description.append(", ")
                    }
                }
                
                // add new line
                if trapline != self.traplines.last {
                    description.append(", ")
                }
            }
            return description
        }
    }
    
    private func getTraplines(from stations: List<Station>) -> List<Trapline> {
        
        let traplines = List<Trapline>()
        
        for station in stations {
            if let trapline = station.trapline {
                if traplines.filter({ $0.code == trapline.code }).isEmpty {
                    traplines.append(trapline)
                }
            }
        }
        
        return traplines
    }
    
    private func traplinesDescription(for traplines: List<Trapline>) -> String {
        
        var description = ""
        
        for trapline in traplines {
            if let code = trapline.code {
                description.append(code)
                if trapline != self.traplines.last {
                    description.append(", ")
                }
            }
        }
        
        return description
    }
    
    private func stationsRangeDescriptions(for trapline: Trapline) -> [String] {
        
        // Get an ordered array of stations for the given trapline
        let stations = self.stations.filter({
            station in
            return station.trapline! == trapline
        }).sorted(by: {
            (station1, station2) in
            return station1.code! < station2.code!
        })
        
        var ranges = [String]()
        var lowRange: String?
        
        for count in 0...stations.count {
            
            if count == 0 {
                lowRange = stations[count].code!
            } else {
            
                let station = count < stations.count ? stations[count] : nil
                
                let lastCodeValue = Int(stations[count - 1].code!) ?? 0
                let thisCodeValue = station != nil ? Int(station!.code!) : 1000 // artificial last station
                if thisCodeValue != lastCodeValue + 1 {
                    
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
