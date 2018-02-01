//
//  Import.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import CSVImporter

struct ErrorDescription {
    var lineNumber: Int
    var field: String
    var value: String?
    var reason: String
}

struct ImportSummary {
    var lineCount: Int = 0
    var summary: String?
}

class DataImport {
    
    var fileURL: URL?
    var contentString: String?
    
    required init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    required init(contentString: String) {
        self.contentString = contentString
    }
    
    var importer: CSVImporter<[String: String]>? {
        if let url = self.fileURL {
            return CSVImporter<[String: String]>(url: url)
        } else if let contentString = self.contentString {
            return CSVImporter<[String: String]>(contentString: contentString)
        }
        return nil
    }
        
    // MARK: - Must override
    
    /**
     Parses the file to check each row and field is valid. For each invalid fields the onError callback is called. If this function returns false, validation is cancelled, otherwise it keeps going.
    */
    func validateFile(onError: ((ErrorDescription) -> Void)?, onCompletion: ((ImportSummary) -> Void)?) {
        // must be overridden
    }
    
    /**
     Import the data located at the file location, if a record exists it will be update, otherwise it will be added to the data store
    */
    func importAndMerge(onError: ((ErrorDescription) -> Bool)?, onProgress: ((Int) -> Void)?, onCompletion: ((ImportSummary) -> Void)?) {
        // must be overridden
    }
    
    
    /**
    Converts a v2 trapline code into v1. This includes ignoring any text after a dash (-) and trimming leading and trailing whitespace
    */
    func convertV1TraplineCodeToV2(v1TraplineCode: String) -> String {
        var v2Code = v1TraplineCode
        if let index = v1TraplineCode.index(of: "-") {
            v2Code = v1TraplineCode[..<index].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return v2Code
    }
}
