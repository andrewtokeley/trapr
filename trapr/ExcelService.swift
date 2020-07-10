//
//  ExcelService.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 8/04/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
import XlsxReaderWriter

enum ExcelServiceError: Error {
    case generalError
    case fileNotSaved
}

class ExcelService {
    
    fileprivate lazy var traplineService = { ServiceFactory.sharedInstance.traplineFirestoreService }()
    fileprivate lazy var regionService = { ServiceFactory.sharedInstance.regionFirestoreService }()
    fileprivate lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    fileprivate lazy var userService = { ServiceFactory.sharedInstance.userService }()
    
    fileprivate let VISIT_REPORT_TEMPLATE = "East_Ridge_C4_v4"
    fileprivate let ATTACHMENT_FILENAME_TEMP = "TempExportFile.xlsx"
    
    fileprivate let VISIT_REPORT_REGION_ROW = 2
    fileprivate let VISIT_REPORT_OPERATOR_ROW = 3
    fileprivate let VISIT_REPORT_DATE_ROW = 4
    fileprivate let VISIT_REPORT_TRAPLINE_ROW = 5
    
    fileprivate let VISIT_REPORT_DATA_START_ROW = 8
    
    fileprivate enum InfoColumn: String {
        case Info = "B"
    }
    
    fileprivate enum ReportColumn: String {
        case TrapTag = "A"
        case TrapType = "B"
        case BaitAdded = "C"
        case BaitRemoved = "D"
        case Catch = "F"
        case Comments = "G"
    }
}


extension ExcelService: ExcelServiceInterface {
    
    private func extendVisits(visits: [Visit], completion: (([VisitEx]) -> Void)?) {
        
        // convert visits into VisitExt
        var visitsEx = [VisitEx]()
        
        let dispatchGroup = DispatchGroup()
        for visit in visits {
            dispatchGroup.enter()
            self.visitService.extend(visit: visit) { (visitEx) in
                if let visitEx = visitEx {
                    visitsEx.append(visitEx)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(visitsEx.sorted(by: { $0.order! < $1.order! }))
        }
    }
    
    private func updateWorksheet(worksheet: BRAWorksheet, visitSummary: VisitSummary, completion: (() -> Void)?) {
        
        // define the region the visit from an arbitrary trapine visited
        if let traplineId = visitSummary.visits.first?.traplineId {
            traplineService.get(traplineId: traplineId) { (trapline, error) in
                if let trapline = trapline {
                    self.regionService.get(id: trapline.regionCode) { (region, error) in
                        if let region = region {
                            
                            // AREA
                            worksheet.cell(forCellReference: InfoColumn.Info.rawValue + String(self.VISIT_REPORT_REGION_ROW))?.setStringValue(region.name)
                            
                            // OPERATOR
                            //if let userName = visitSummary.visits.first?.userId {
                            if let userName = self.userService.currentUser?.displayName {
                                worksheet.cell(forCellReference: InfoColumn.Info.rawValue + String(self.VISIT_REPORT_OPERATOR_ROW))?.setStringValue(userName)
                            }
                            
                            // DATE
                            worksheet.cell(forCellReference: InfoColumn.Info.rawValue + String(self.VISIT_REPORT_DATE_ROW))?.setStringValue(visitSummary.dateOfVisit.toString(format: Styles.DATE_FORMAT_LONG))
                            
                            // TRAPLINE (actually this is the name of the Route)
                            if let routeName = visitSummary.route?.name {
                                worksheet.cell(forCellReference: InfoColumn.Info.rawValue + String(self.VISIT_REPORT_TRAPLINE_ROW))?.setStringValue(routeName)
                            }
                            
                            // VISIT DATA
                            
                            self.extendVisits(visits: visitSummary.visits) { (visitsEx) in
                                
                                print("Total visits \(visitsEx.count)")
                                
                                for visit in visitsEx {
                                    
                                    let trapTag = visit.station?.longCodeWalkTheLine ?? "?"
                                    let trapType = TrapTypeCode(rawValue: visit.trapType!.id!)?.walkTheLineName
                                    
                                    print("looking for \(trapTag) and \(trapType)")
                                    
                                    if let row = worksheet.findRow(searchTerms: [ColumnSeach(columnReference: ReportColumn.TrapTag.rawValue, value: trapTag), ColumnSeach(columnReference: ReportColumn.TrapType.rawValue, value: trapType)]) {
                                        
                                        print("found row \(row)")
                                        // TRAP TAG
//                                        worksheet.cell(forCellReference: ReportColumn.TrapTag.rawValue + String(row))?.setStringValue(visit.station?.longCode ?? "?")
//
//                                        // TRAP TYPE
//                                        worksheet.cell(forCellReference: ReportColumn.TrapType.rawValue + String(row))?.setStringValue(TrapTypeCode(rawValue: visit.trapType!.id!)?.walkTheLineName)
                                        
                                        if visit.trapType?.killMethod == .poison {
                                        
                                            // BAIT ADDED
//                                            worksheet.cell(forCellReference: ReportColumn.BaitAdded.rawValue + String(row))?.setStringValue(String(visit.baitAdded))
//
                                            worksheet.cell(forCellReference: ReportColumn.BaitAdded.rawValue + String(row))?.setStringValue(String(visit.baitAdded))
                                            
                                            // BAIT REMOVE 
                                            worksheet.cell(forCellReference: ReportColumn.BaitRemoved.rawValue + String(row))?.setStringValue(String(visit.baitRemoved))
                                        
                                        } else {
                                            
                                            // CATCH
                                            if visit.species != nil {
                                                
                                                // CATCH CODE
                                                worksheet.cell(forCellReference: ReportColumn.Catch.rawValue + String(row))?.setStringValue(SpeciesCode(rawValue: visit.species!.id!)?.walkTheLineCode)
                                                
                                            } else {
                                                
                                                // TRAP STATUS CODE
                                                if let code = visit.trapSetStatus?.walkTheLineCode {
                                                    worksheet.cell(forCellReference: ReportColumn.Catch.rawValue + String(row))?.setStringValue(String(code))
                                                }
                                            }
                                        }
                                        
                                        // COMMENT
                                        worksheet.cell(forCellReference: ReportColumn.Comments.rawValue + String(row))?.setStringValue(visit.notes)
                                        
                                    }
                                }
                                completion?()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func generateVisitReportFile(visitSummary: VisitSummary, completion: ((Data?, String?, Error?) -> Void)?) {

        let path = Bundle.main.path(forResource: VISIT_REPORT_TEMPLATE, ofType: "xlsx")
        
        if let spreadsheet = BRAOfficeDocumentPackage.open(path) {
            if let worksheet: BRAWorksheet = spreadsheet.workbook.worksheets.first as? BRAWorksheet {
         
                // makes some changes..
                self.updateWorksheet(worksheet: worksheet, visitSummary: visitSummary) {
                
                    // save a copy to user's document directory
                    if let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last {
                        
                        // update worksheet with visit data
                        self.updateWorksheet(worksheet: worksheet, visitSummary: visitSummary) {
                            //
                        
                            
                            if let saveFilePath = NSURL(fileURLWithPath: directoryPath).appendingPathComponent(self.ATTACHMENT_FILENAME_TEMP)?.path {
                                
                                // Save report file
                                spreadsheet.save(as: saveFilePath)
                            
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: saveFilePath) {
                                    if let fileData = try? NSData(contentsOfFile: saveFilePath) as Data {
                                        completion?(fileData, "application/vnd.ms-excel", nil)
                                    } else {
                                        completion?(nil, nil, ExcelServiceError.generalError)
                                    }
                                } else {
                                    completion?(nil, nil, ExcelServiceError.fileNotSaved)
                                }
                            } else {
                                completion?(nil, nil, ExcelServiceError.generalError)
                            }
                        }
                    }
                }
            }
        }
    }
}
