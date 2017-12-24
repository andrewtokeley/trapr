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
}

enum TrapTypeDescriptions: String {
    case possumMaster = "Possum Master"
    case pelifeed = "Pelifeed"
    case doc200 = "Haines Trap"
}

class importer_traplines_v1_to_v2: DataImport {
    
    // MARK: - Properties
    
    fileprivate var traplineService: TraplineServiceInterface {
        return ServiceFactory.sharedInstance.traplineService
    }
    
    fileprivate var fileURL: URL?
    fileprivate var contentString: String?
    
    fileprivate var importer: CSVImporter<[String: String]>? {
        if let url = self.fileURL {
            return CSVImporter<[String: String]>(url: url)
        } else if let contentString = self.contentString {
            return CSVImporter<[String: String]>(contentString: contentString)
        }
        return nil
    }
    
    // MARK: - Initialisers
    
    required init(fileURL: URL) {
        self.fileURL = fileURL
    }

    required init(contentString: String) {
        self.contentString = contentString
    }
    
    //MARK: - DataImport
    
    private func checkColumnExists(columnHeading: TraplineFileHeaders, headerValues: [String]) -> Bool {
        return headerValues.contains(where: { $0 == columnHeading.rawValue })
    }
    
    func validateFile(onError: ((ErrorDescription) -> Void)?, onCompletion: ((ImportSummary) -> Void)?) {
        
        self.importer?.startImportingRecords(structure: { (headerValues) -> Void in
            // must have column called "Trap Line" and "Summary"
            
            for heading in [TraplineFileHeaders.trapline_code, TraplineFileHeaders.trapline_summary] {
                if !self.checkColumnExists(columnHeading: heading, headerValues: headerValues) {
                    onError?(ErrorDescription(lineNumber: 0, field: heading.rawValue, value: nil, reason: "Column heading, '\(heading.rawValue) is missing"))
                }
            }
            
        }) { $0 }.onFinish { importedRecords in
            let summary = ImportSummary(summary: "Done!")
            onCompletion?(summary)
        }
    }
    
    func importAndMerge(onError: ((ErrorDescription) -> Bool)?, onCompletion: ((ImportSummary) -> Void)?) {
        
        self.importer?.startImportingRecords(structure: { (headerValues) -> Void in
            
            // do nothing
            print("header!")
        }) { $0 }.onFail {
            
            onCompletion?(ImportSummary(summary: "Done!"))
            
        }.onProgress { importedDataLinesCount in
                
                print("\(importedDataLinesCount) lines were already imported.")
                
        }.onFinish { importedRecords in
            
            var summary = ImportSummary()
            
            for record in importedRecords {
                
                if let trapline = self.addOrUpdateTrapline(record) {
                    
                    if let station = self.addOrUpdateStation(record, trapline: trapline) {
                    
                        if let _ = self.addOrUpdateTrap(record, station: station) {
                            
                        }
                    }
                }
            }
            summary.summary = "Done"
            onCompletion?(summary)
            
        }
    }
    
    //MARK: - Add/Update functions
    
    private func addOrUpdateTrapline(_ record: [String: String]) -> Trapline? {
        
        var trapline:Trapline?
        
        if let traplineCode = record[TraplineFileHeaders.trapline_code.rawValue] {
            
            // ignore anything after "-"
            var code = traplineCode
            if let index = traplineCode.index(of: "-") {
                code = traplineCode.substring(to: index).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            // see if it exists
            trapline = self.traplineService.getTrapline(code: code)
            
            if let _ = trapline {
                // updating an existing trapline
                // take a copy so we can update details
                trapline = Trapline(value: trapline!)
                
            } else {
                // we're adding a new trapline
                trapline = Trapline()
                trapline?.code = code
            }
            
            trapline?.details = record[TraplineFileHeaders.trapline_summary.rawValue]
            
            // add/update trapline
            self.traplineService.add(trapline: trapline!)
        }
        
        return trapline
    }
    
    private func addOrUpdateStation(_ record: [String: String], trapline: Trapline) -> Station? {
        
        var station: Station?
        
        //get the numeric values from the Trap Name - this will be the station code
        if let trapName = record[TraplineFileHeaders.station_code.rawValue] {
            
            let stationCode = String(trapName.filter { "0"..."9" ~= $0 })
            if stationCode.count != 0 {
                
                // see if it exists
                station = trapline.stations.first(where: { $0.code == stationCode })
                
                if station == nil {
                    station = Station(code: stationCode)
                }
                
                traplineService.addStation(trapline: trapline, station: station!)
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
            case TrapTypeDescriptions.possumMaster.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.possumMaster)
            case TrapTypeDescriptions.doc200.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.doc200)
            case TrapTypeDescriptions.pelifeed.rawValue:
                trap!.type = ServiceFactory.sharedInstance.trapTypeService.get(.pellibait)
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