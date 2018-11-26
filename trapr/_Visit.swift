//
//  _Visit.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

import FirebaseFirestore

enum VisitFields: String {
    case visitDate = "dateTime"
    case routeId = "route"
    case traplineId = "trapline"
    case trapTypeId = "trapType"
    case speciesId = "species"
    case stationId = "station"
    case lureId = "lure"
    case baitEaten = "baitEaten"
    case baitAdded = "baitAdded"
    case baitRemoved = "baitRemoved"
    case trapSetStatusId = "trapSetStatus"
    case trapOperatingStatusId = "trapOperatingStatus"
    case notes = "notes"
}

class _Visit: DocumentSerializable {
    
    /**
     Composite key in the format ddMMyyyy-stationId-trapTypeId
     */
    var id: String?

    // These fields must be set on initialisation
    var trapTypeId: String
    var visitDateTime: Date = Date()
    var routeId: String
    var stationId: String
    var traplineId: String
    
    var trapOperatingStatusId: Int = 0
    var trapOperatingStatus: TrapOperatingStatus {
        return TrapOperatingStatus(rawValue: trapOperatingStatusId) ?? .open
    }
    
    
    var baitAdded: Int = 0
    var baitEaten: Int = 0
    var baitRemoved: Int = 0
    
    var trapSetStatusId: Int = 0
    var trapSetStatus: TrapSetStatus {
        return TrapSetStatus(rawValue: trapSetStatusId) ?? .stillSet
    }
    
    // optionals
    var lureId: String?
    var speciesId: String?
    var notes: String?

    /**
     TODO: see if Firebase is better at this...
     
     Computed property that allows visits to be ordered by Station then Trap order.
     
     For example, LW01_0
     
     Note, realm still won't be able to sort on this as it's not persisted to the database
     */
//    @objc var order: String {
//        let code = trap?.station?.longCode ?? "_"
//        let trapOrder = String(trap?.type?.order ?? 0)
//        return "\(code)_\(trapOrder)"
//    }
    
    var dictionary: [String: Any] {
        
        var result = [String: Any]()
        
        // values for these fields will always exist
        result[VisitFields.visitDate.rawValue] = visitDateTime
        result[VisitFields.routeId.rawValue] = routeId
        result[VisitFields.stationId.rawValue] = stationId
        result[VisitFields.visitDate.rawValue] = visitDateTime
        result[VisitFields.baitAdded.rawValue] = baitAdded
        result[VisitFields.baitEaten.rawValue] = baitEaten
        result[VisitFields.baitRemoved.rawValue] = baitRemoved
        result[VisitFields.trapTypeId.rawValue] = trapTypeId
        result[VisitFields.traplineId.rawValue] = traplineId
        result[VisitFields.trapSetStatusId.rawValue] = trapSetStatusId
        result[VisitFields.trapOperatingStatusId.rawValue] = trapOperatingStatusId
        
        // these fields might be defined
        if let _ = notes { result[VisitFields.notes.rawValue] = notes }
        if let _ = speciesId { result[VisitFields.speciesId.rawValue] = speciesId }
        if let _ = lureId { result[VisitFields.lureId.rawValue] = lureId }
        
        return result
    }
    
    init(date: Date, routeId: String, traplineId: String, stationId: String, trapTypeId: String) {
        let ddmmyyyy = date.toString(format: "ddMMYYYY")
        self.id = "\(ddmmyyyy)-\(stationId)-\(trapTypeId)"
        self.visitDateTime = date
        self.routeId = routeId
        self.traplineId = traplineId
        self.stationId = stationId
        self.trapTypeId = trapTypeId
        
        // TODO - see if we can avoid needing this for a new Visit
        //self.lure = trap.type?.defaultLure
    }
    
    required init?(dictionary: [String: Any]) {
        
        // check for mandatory fields
        guard
            let visitDate = dictionary[VisitFields.visitDate.rawValue] as? Timestamp,
            let trapTypeId = dictionary[VisitFields.trapTypeId.rawValue] as? String,
            let routeId = dictionary[VisitFields.routeId.rawValue] as? String,
            let stationId = dictionary[VisitFields.stationId.rawValue] as? String,
            let traplineId = dictionary[VisitFields.traplineId.rawValue] as? String
        else {
            return nil
        }
        
        // set mandatory fields
        self.visitDateTime = visitDate.dateValue()
        self.trapTypeId = trapTypeId
        self.routeId = routeId
        self.stationId = stationId
        self.traplineId = traplineId
        
        // set optional if they're in the dictionary
        if let speciesId = dictionary[VisitFields.speciesId.rawValue] as? String {
            self.speciesId = speciesId
        }
        if let lureId = dictionary[VisitFields.lureId.rawValue] as? String {
            self.lureId = lureId
        }
        if let baitAdded = dictionary[VisitFields.baitAdded.rawValue] as? Int {
            self.baitAdded = baitAdded
        }
        if let baitEaten = dictionary[VisitFields.baitEaten.rawValue] as? Int {
            self.baitEaten = baitEaten
        }
        if let baitRemoved = dictionary[VisitFields.baitRemoved.rawValue] as? Int {
            self.baitRemoved = baitRemoved
        }
        if let notes = dictionary[VisitFields.notes.rawValue] as? String {
            self.notes = notes
        }
        if let trapSetStatusId = dictionary[VisitFields.trapSetStatusId.rawValue] as? Int {
            self.trapSetStatusId = trapSetStatusId
        }
        if let trapOperatingStatusId = dictionary[VisitFields.trapOperatingStatusId.rawValue] as? Int {
            self.trapOperatingStatusId = trapOperatingStatusId
        }
    }
    
}
