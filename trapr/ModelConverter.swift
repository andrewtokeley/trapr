//
//  ModelConverter.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class ModelConverter {
    
    static func Visit(_ visit: Visit) -> Visit? {
        
        if let regionId = visit.trap?.station?.trapline?.region?.code, let traplineId = visit.trap?.station?.trapline?.code, let stationCode = visit.trap?.station?.code {
            let stationId = "\(regionId)-\(traplineId)-\(stationCode)"
            let visitFireStore = Visit(date: visit.visitDateTime, routeId: visit.route!.id, traplineId: visit.trap!.station!.trapline!.id!, stationId: stationId, trapTypeId: visit.trap!.type!.code!)
            visitFireStore.baitAdded = visit.baitAdded
            visitFireStore.baitEaten = visit.baitEaten
            visitFireStore.baitRemoved = visit.baitRemoved
            visitFireStore.notes = visit.notes
            visitFireStore.speciesId = visit.catchSpecies?.code
            visitFireStore.lureId = visit.lure?.code
            
            return visitFireStore
        }
        return nil
    }
    
    static func Region(_ region: Region) -> _Region? {
        if let id = region.code, let name = region.name {
            return _Region(id: id, name: name, order: 0)
        }
        return nil
    }
    
    static func Route(_ route: Route) -> _Route? {
        if let name = route.name {
            let routeFS = _Route(name: name, stationIds: [String]())
            for station in route.stations {
                // get the FS id for the station
                if let traplineFS = ModelConverter.Trapline(station.trapline!) {
                    if let stationFS = ModelConverter.Station(station: station, traplineIdFS: traplineFS.id!) {
                        routeFS.stationIds.append(stationFS.id!)
                    }
                }
            }
            return routeFS
        }
        return nil
    }
    
    static func Trapline(_ trapline: Trapline) -> Trapline? {
        if let code = trapline.code, let regionCode = trapline.region?.code {
            return Trapline(code: code, regionCode: regionCode, details: trapline.details ?? "")
        }
        return nil
    }
    
    static func Station(station: Station, traplineIdFS: String) -> Station? {
        if let number = station.codeAsNumber {
            let stationFS = Station(traplineId: traplineIdFS, number: number)
            stationFS.latitude = station.latitude
            stationFS.longitude = station.longitude
            stationFS.traplineCode = station.trapline?.code
            stationFS.routeId = nil // (will get set later in merge process)
            for trap in station.traps {
                if let code = trap.type?.code {
                    stationFS.trapTypes.append(TrapTypeStatus(trapTpyeId: code, active: !trap.archive))
                }
            }
            return stationFS
        }
        return nil
    }
}
