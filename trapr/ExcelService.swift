//
//  ExcelService.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 8/04/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
//import XlsxReaderWriter

class ExcelService {
    fileprivate let VISIT_REPORT_TEMPLATE_FILE = "VisitReportTemplate.xlsx"
}

extension ExcelService: ExcelServiceInterface {
    
    func generateVisitReportFile(visitSummary: VisitSummary, completion: ((String, Error) -> Void)?) {

        let path = Bundle.main.path(forResource: VISIT_REPORT_TEMPLATE_FILE, ofType: "xlsx")
        
 //       let spreadsheet = BRAOfficeDocumentPackage(open: path)
//        NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"testWorkbook" ofType:@"xlsx"];
//        BRAOfficeDocumentPackage *spreadsheet = [BRAOfficeDocumentPackage open:documentPath];
    }
}
