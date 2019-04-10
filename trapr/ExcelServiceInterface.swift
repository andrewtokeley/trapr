//
//  ExcelServiceInterface.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 8/04/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol ExcelServiceInterface {
    
    /**
     Generate an Excel file that summarises a visit to a series of traps, including bait added/removed and species caught. The format of this file is intended to be used by operators to upload into the Walk the Line application developed by DOC.
     
     - parameters:
        - visitSummary: the visits to report on
        - completion: a closure to be called that will include the path to the file or an Error as its parameters
     */
    func generateVisitReportFile(visitSummary: VisitSummary, completion: ((String, Error) -> Void)?)
    
}
