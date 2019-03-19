//
//  HtmlService.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

struct RowDefinition<T: Any> {
    var title: String
    var width: Int
    var alignment: String
    var value: (T) -> String?
}

//struct TableHeadingDefinition {
//    var title: String
//    var width: Int
//    var alignment: String
//}

class HtmlService {
    
    fileprivate let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    fileprivate let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    fileprivate let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    fileprivate let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    fileprivate let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    
    fileprivate let rowDefinitions: [RowDefinition<VisitEx>] = [
        RowDefinition<VisitEx>(title: "Trap", width: 80, alignment: "left", value: { $0.stationName } ),
        RowDefinition<VisitEx>(title: "Type", width: 150, alignment: "left", value: { $0.trapTypeName } ),
        RowDefinition<VisitEx>(title: "Time", width: 80, alignment: "left", value: { $0.visitDateTime.toString(format: Styles.DATE_FORMAT_TIME) } ),
        RowDefinition<VisitEx>(title: "Added", width: 80, alignment: "right", value: { String($0.baitAdded) }),
        RowDefinition<VisitEx>(title: "Eaten", width: 80, alignment: "right", value: { String($0.baitEaten) }),
        RowDefinition<VisitEx>(title: "Removed", width: 80, alignment: "right", value: { String($0.baitRemoved) }),
        RowDefinition<VisitEx>(title: "Catch", width: 80, alignment: "right", value: { $0.speciesId == nil ? "-" : "1" } ),
        RowDefinition<VisitEx>(title: "Species", width: 150, alignment: "right", value: { $0.speciesName  } ),
        RowDefinition<VisitEx>(title: "Notes", width: 150, alignment: "right", value: { $0.notes } )
    ]
}

extension HtmlService: HtmlServiceInterface {
    
    func getVisitsAsHtml(recordedOn date: Date, route: Route, completion: ((String?) -> Void)?) {
        
        var html = "<html><table style=\'border-collapse : collapse;\'>"

        self.visitService.get(recordedOn: date, routeId: route.id!) { (visits, error) in

            // HEADING
            html.append(self.htmlForHeadings(rowDefinitions: self.rowDefinitions))

            // ROUTE NAME AND DATE
            html.append(self.htmlForGroupHeader(route: route, date: date, colspan:
                            self.rowDefinitions.count))

            // VISITS
            let dispatchGroup = DispatchGroup()
            
            for visit in visits {
                dispatchGroup.enter()
                self.visitService.extend(visit: visit, completion: { (visitEx) in
                    if let visitEx = visitEx {
                        html.append(self.htmlForRow(rowDefinitions: self.rowDefinitions, data: visitEx))
                        dispatchGroup.leave()
                    }
                })
            }
        
            // close tags when visits all added
            dispatchGroup.notify(queue: .main, execute: {
                html.append("</table></html>")
                completion?(html)
            })
        }
    }
    
    
    /**
     Get the headings row for the table
     */
    func htmlForHeadings(rowDefinitions: [RowDefinition<VisitEx>]) -> String {
     
        /**
         <tr>
            <th style='min-height:20px; min-width:100px; border-bottom:2px double black;'><p>Heading1</p></th>
            ...
         </tr>
        */
        
        var html = "<tr>"
        
        // add <th> for each heading
        for definition in rowDefinitions  {
            let th = "<th align='\(definition.alignment)' style=\'min-height:20px; min-width:\(definition.width)px; border-bottom:2px double black;'><p>\(definition.title)</p></th>"
            html.append(th)
        }
        
        // close row tag
        html.append("</tr>")
        
        return html
    }
    
    
    func htmlForGroupHeader(route: Route, date: Date, colspan: Int) -> String {
        return "<tr style=\'border-bottom:2px solid black\'><td style=\'min-height:50px; border-bottom:1px solid black;\' colspan=\(colspan)><b>\(route.name) - \(date.toString(format: Styles.DATE_FORMAT_LONG))</b></br></td></tr>"
    }

    func htmlForRow(rowDefinitions: [RowDefinition<VisitEx>], data: VisitEx) -> String {
        
        var html = "<tr>"
        let rowFormat = "<td align=\'%@\' style=\'min-width:%dpx; border-bottom:1px solid black;\'>%@</td>"
        
        for definition in self.rowDefinitions {
            html.append(String(format: rowFormat, definition.alignment, definition.width, definition.value(data) ?? "" ))
        }
        
        html.append("</tr>")
        return html
    }

}
