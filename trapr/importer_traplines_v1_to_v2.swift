//
//  importer_v1_to_v2.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import CSVImporter

enum TraplineFileHeaders: String {
    case trapline_code = "Trap Line"
    case trapline_summary = "Summary"
    case station_code = "Trap Name"
    case trap_type = "Trap Type"
    case trap_latitude = "Latitude"
    case trap_longitude = "Longitude"
    case trap_notes = "Notes"
    case region_code = "Region Code"
    case region_name = "Region Name"
}

/**
 These are the names given to trap types from the v1 app. Note some are incorrectly named, but are still mapped to the correct type
 */
enum V1TrapTypeDescriptions: String {
    case possumMaster = "Possum Master"
    case pelifeed = "Pelifeed"
    case doc200_1 = "Haines Trap"
    case doc200_2 = "DOC200"
    case timms = "Timms"
}

class importer_traplines_v1_to_v2: DataImport {
    
    // MARK: - Properties
    
//    fileprivate var traplineService: TraplineServiceInterface {
//        return ServiceFactory.sharedInstance.traplineService
//    }
//
//    fileprivate var regionService: RegionServiceInterface {
//        return ServiceFactory.sharedInstance.regionService
//    }
    
    private func checkColumnExists(columnHeading: TraplineFileHeaders, headerValues: [String]) -> Bool {
        return headerValues.contains(where: { $0 == columnHeading.rawValue })
    }
    
    //MARK: - DataImport overrides
    
    override func validateFile(onError: ((ErrorDescription) -> Void)?, onCompletion: ((ImportSummary) -> Void)?) {
        
        self.importer?.startImportingRecords(structure: { (headerValues) -> Void in
            
            // must have column called "Trap Line", "Summary", "Region Code", "Region Name"
            for heading in [TraplineFileHeaders.trapline_code, TraplineFileHeaders.trapline_summary, TraplineFileHeaders.region_code, TraplineFileHeaders.region_name] {
                if !self.checkColumnExists(columnHeading: heading, headerValues: headerValues) {
                    onError?(ErrorDescription(lineNumber: 0, field: heading.rawValue, value: nil, reason: "Column heading, '\(heading.rawValue) is missing"))
                }
            }
            
        }) { $0 }.onFinish { importedRecords in
            let summary = ImportSummary(lineCount: importedRecords.count, summary: "\(importedRecords.count) records imported.")
            onCompletion?(summary)
        }
    }
    
    override func importAndMerge(onError: ((ErrorDescription) -> Bool)?, onProgress: ((Int) -> Void)? = nil, onCompletion: ((ImportSummary) -> Void)?) {
        
        self.importer?.startImportingRecords(structure: { (headerValues) -> Void in
            // do nothing
            //print("header read")
        }) { $0 }.onFail {
            //print("fail")
            onCompletion?(ImportSummary(lineCount: 0, summary: "Fail"))
        }.onProgress { importedDataLinesCount in
            //print("progress, imported \(importedDataLinesCount) lines")
            onProgress?(importedDataLinesCount)
        }.onFinish { importedRecords in
            //print("import complete, \(importedRecords.count) records imported")
            var summary = ImportSummary()
            
            for record in importedRecords {
                
                if let region = self.addOrUpdateRegion(record) {
                    
                    if let trapline = self.addOrUpdateTrapline(record, region: region) {
                    
                        if let station = self.addOrUpdateStation(record, trapline: trapline) {
                        
                            if let _ = self.addOrUpdateTrap(record, station: station) {
                                
                            }
                        }
                    }
                }
            }
            
            summary.summary = "Done"

            onCompletion?(summary)
            
        }
    }
    
    //MARK: - Add/Update functions
    
    private func addOrUpdateRegion(_ record: [String: String]) -> Region? {
        
        var region:Region?
        
        if let regionCode = record[TraplineFileHeaders.region_code.rawValue],
            let regionName = record[TraplineFileHeaders.region_name.rawValue] {
            
            region = Region()
            region!.code = regionCode
            region!.name = regionName
            
            self.regionService.add(region: region!)
        }
        return region
    }
    
    private func addOrUpdateTrapline(_ record: [String: String], region: Region) -> Trapline? {
        
        var trapline:Trapline?
        
        if let traplineCode = record[TraplineFileHeaders.trapline_code.rawValue] {
            
            // ignore anything after "-"
            let code = convertV1TraplineCodeToV2(v1TraplineCode: traplineCode)
            
            // get the trapline to add/update
            // see if it exists
            //trapline = self.traplineService.getTrapline(code: code)
            trapline = self.traplineService.getTrapline(region: region, code: code)
            
            if let _ = trapline {
                // updating an existing trapline
                // take a copy so we can update details
                trapline = Trapline(value: trapline!)
                
            } else {
                // we're adding a new trapline
                trapline = Trapline(region: region, code: code)
            }
            
            trapline?.details = record[TraplineFileHeaders.trapline_summary.rawValue]
            
            // add/update trapline
            if let _ = try? self.traplineService.add(trapline: trapline!) {
                return trapline
            }
        }
        
        return nil
    }
    
    private func addOrUpdateStation(_ record: [String: String], trapline: Trapline) -> Station? {
        
        var station: Station?
        
        if let trapName = record[TraplineFileHeaders.station_code.rawValue] {
            
            //get the numeric values from the Trap Name - this will be the station code
            let stationCode = String(trapName.filter { "0"..."9" ~= $0 })
            if stationCode.count != 0 {
                
                // see if it exists
                station = trapline.stations.first(where: { $0.code == stationCode })
                
                // if the station doesn't exists already, add it
                if station == nil {
                    station = Station(code: stationCode)
                    traplineService.addStation(trapline: trapline, station: station!)
                }
                
            } else {
                // warning that there's no station code?
            }
        }
        
        return station
    }

    private func addOrUpdateTrap(_ record: [String: String], station: Station) -> Trap? {
        
        var trap: Trap?
        
        // get the trap type from the description
        if let trapTypeName = record[TraplineFileHeaders.trap_type.rawValue] {
            trap = Trap()
            
            switch trapTypeName {
            case V1TrapTypeDescriptions.possumMaster.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.possumMaster)
            case V1TrapTypeDescriptions.doc200_1.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.doc200)
            case V1TrapTypeDescriptions.doc200_2.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.doc200)
            case V1TrapTypeDescriptions.pelifeed.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.pellibait)
            case V1TrapTypeDescriptions.timms.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.timms)
            default:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.other)
            }
            
            if let longitude = record[TraplineFileHeaders.trap_longitude.rawValue] {
                trap!.longitude = Double(longitude.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            }
            
            if let latitude = record[TraplineFileHeaders.trap_latitude.rawValue] {
                trap!.latitude = Double(latitude.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            }
            
            if let notes = record[TraplineFileHeaders.trap_notes.rawValue] {
                trap!.notes = notes
            }
            
            traplineService.addTrap(station: station, trap: trap!)
        }
        
        return trap
    }
}
