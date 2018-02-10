//
//  Route.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum TimeFrequency: Int {
    case week = 0
    case fortnight = 1
    case month = 2
    case twoMonths = 3
    case sixMonths = 4
    case year = 5
    
    var name: String {
        switch self {
        case .week: return "Weekly"
        case .fortnight: return "Fornightly"
        case .month: return "Monthly"
        case .twoMonths: return "Every 2 months"
        case .sixMonths: return "Every 6 months"
        case .year: return "Annually"
        }
    }
    
    static var count: Int {
        return TimeFrequency.all.count
    }
    
    static var all: [TimeFrequency] {
        return [.week, .fortnight, .month, .twoMonths, .sixMonths, .year]
    }
    
    static var defaultValue: TimeFrequency {
        return TimeFrequency.month
    }
}

class Route: Object {
    
    //MARK: - Persisted Properties
    
    @objc dynamic var id: String = UUID().uuidString
    
    /**
     The stations defined on the route
     */
    let stations = List<Station>()
    
    /**
     Human readable name for the route. Set by the user.
     */
    @objc dynamic var name: String?
    
    /**
     The value that actually gets stored in the database. Where possible, use the property visitFrequency
     */
    @objc dynamic var visitFrequencyRaw: Int = 0
    
    /**
     Determine's whether the route is hidden from the main app dashboard. Useful for hiding Routes that are no longer visited but which you still want to keep the visit data on the phone for.
     */
    @objc dynamic var isHidden: Bool = false
    
    @objc dynamic var dashboardImage: SavedImage?
    
    
    
    //MARK: - Read-Only Properties
    
    /**
    Returns the traplines that are contained within the Route. Traplines that are only partially visited are also returned.
    */
    var traplines: [Trapline] {
        return ServiceFactory.sharedInstance.stationService.getTraplines(from: Array(self.stations))
    }
    
    /**
    Returns the TimeFrequency at which visits should occur
    */
    var visitFrequency: TimeFrequency {
        return TimeFrequency(rawValue: visitFrequencyRaw) ?? .month
    }
    
    /**
     A short description of the route based on the stations. e.g. L, N
     */
    var shortDescription: String {
        return ServiceFactory.sharedInstance.stationService.getDescription(stations: Array(self.stations), includeStationCodes: false)
    }
   
    /**
    A long description of the route based on the stations. e.g. LW01-LW11, N30-N35
    */
    var longDescription: String {
        return ServiceFactory.sharedInstance.stationService.getDescription(stations: Array(self.stations), includeStationCodes: true)
    }
    
    /**
    Path (either local or remote) to route's hero image
     */
    //var imageUrlPath: String?
    
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
    
}
