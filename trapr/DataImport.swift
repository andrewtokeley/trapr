//
//  Import.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

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

protocol DataImport {
    
    init(fileURL: URL)
    
    init(contentString: String)
    
    /**
     Parses the file to check each row and field is valid. For each invalid fields the onError callback is called. If this function returns false, validation is cancelled, otherwise it keeps going.
    */
    func validateFile(onError: ((ErrorDescription) -> Void)?, onCompletion: ((ImportSummary) -> Void)?)
    
    /**
     Import the data located at the file location, if a record exists it will be update, otherwise it will be added to the data store
    */
    func importAndMerge(onError: ((ErrorDescription) -> Bool)?, onProgress: ((Int) -> Void)?, onCompletion: ((ImportSummary) -> Void)?)
}
