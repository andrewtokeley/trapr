//
//  importer_visits_v1_to_v2.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

enum VisitsFileHeaders: String {
    case trapline_code = "Trap Line"
    case station_code = "Trap Name"
    case trap_type = "Trap Type"
    case visit_date = "Visit Date"
    case visit_bait_added = "Bait Added"
    case visit_bait_removed = "Bait Removed"
    case visit_bait_eaten = "Bait Eaten"
    case visit_species = "Species"
    case visit_notes = "Notes"
}

enum V1SpeciesDescription: String {
    case possum = "Possum"
}

import Foundation

class importer_visits_v1_to_v2: DataImport {
    
    override func validateFile(onError: ((ErrorDescription) -> Void)?, onCompletion: ((ImportSummary) -> Void)?) {
        
        self.importer?.startImportingRecords(structure: { (headerValues) -> Void in
    
            if headerValues.contains(VisitsFileHeaders.trapline_code.rawValue) &&
            headerValues.contains(VisitsFileHeaders.station_code.rawValue) &&
            headerValues.contains(VisitsFileHeaders.trap_type.rawValue) &&
            headerValues.contains(VisitsFileHeaders.visit_date.rawValue) &&
            headerValues.contains(VisitsFileHeaders.visit_bait_added.rawValue) &&
            headerValues.contains(VisitsFileHeaders.visit_bait_removed.rawValue) &&
            headerValues.contains(VisitsFileHeaders.visit_bait_removed.rawValue) &&
            headerValues.contains(VisitsFileHeaders.visit_species.rawValue) &&
            headerValues.contains(VisitsFileHeaders.visit_notes.rawValue) {
                // all good
            } else {
                onError?(ErrorDescription(lineNumber: 0, field: "", value: "", reason: "Missing columns"))
            }
            
        }) { $0 }.onFinish { importedRecords in
            let summary = ImportSummary(lineCount: importedRecords.count, summary: "\(importedRecords.count) record validated.")
            onCompletion?(summary)
        }
    }
    
    override func importAndMerge(onError: ((ErrorDescription) -> Bool)?, onProgress: ((Int) -> Void)?, onCompletion: ((ImportSummary) -> Void)?) {
        
        // Trap Line,Trap Name,Trap Type,Latitude,Longitude,Visit Date,Bait Added,Bait Removed,Bait Eaten,Catches,Species,Notes
        //let service = ServiceFactory.sharedInstance.visitService
        
        //let visit = Visit(date: date, route: route, trap: trap)

    }
    
}
