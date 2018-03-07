//
//  HtmlService.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

struct RowDefinition<T: Object> {
    var title: String
    var width: Int
    var alignment: String
    var value: (T) -> String
}

struct TableHeadingDefinition {
    var title: String
    var width: Int
    var alignment: String
}

class HtmlService: HtmlServiceInterface {
    
    private var PLACEHOLDER: String = "@"
    private let rowDefinitions = [
        RowDefinition<Visit>(title: "Trap", width: 80, alignment: "left", value: { $0.trap?.station?.longCode ?? "-"} ),
        RowDefinition<Visit>(title: "Type", width: 150, alignment: "left", value: { $0.trap?.type?.name ?? "-"} ),
        RowDefinition<Visit>(title: "Time", width: 80, alignment: "left", value: { $0.visitDateTime.toString(from: Styles.DATE_FORMAT_TIME) } ),
        RowDefinition<Visit>(title: "Added", width: 80, alignment: "right", value: { String($0.baitAdded) }),
        RowDefinition<Visit>(title: "Eaten", width: 80, alignment: "right", value: { String($0.baitEaten) }),
        RowDefinition<Visit>(title: "Removed", width: 80, alignment: "right", value: { String($0.baitRemoved) }),
        RowDefinition<Visit>(title: "Catch", width: 80, alignment: "right", value: { $0.catchSpecies == nil ? "" : "1" } ),
        RowDefinition<Visit>(title: "Species", width: 150, alignment: "right", value: { $0.catchSpecies?.name ?? ""} ),
        RowDefinition<Visit>(title: "Notes", width: 150, alignment: "right", value: { $0.notes ?? ""} )
    ]
    
    //private var headings = [String]()
    
    func getVisitsAsHtml(recordedOn date: Date, route: Route) -> String? {
    
        let visitsFromRealm = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date, route: route)
        
        //let visits = Array(visitsFromRealm).sorted(by: { $0.order < $1.order })
        let visitArray = Array(visitsFromRealm)
        let visits = visitArray.sorted(by: {
            (visit1, visit2) in
            return visit1.order < visit2.order
        }, stable: true)
        
        var html = "<html><table style=\'border-collapse : collapse;\'>"
        
        // HEADING
        html.append(htmlForHeadings(rowDefinitions: rowDefinitions))
        
        // ROUTE NAME AND DATE
        if let route = visits.first?.route {
            if let date = visits.first?.visitDateTime {
                html.append(htmlForGroupHeader(route: route, date: date, colspan: rowDefinitions.count))
            }
        }
        
        // VISITS
        for visit in visits {
            html.append(htmlForRow(rowDefinitions: rowDefinitions, visit: visit))
        }
        
        // close tags
        html.append("</table></html>")
        
        return html
    }
    
    /**
     
     */
    func htmlForHeadings(rowDefinitions: [RowDefinition<Visit>]) -> String {
     
        /**
         <tr>
            <th style='min-height:20px; min-width:100px; border-bottom:2px double black;'><p>Heading1</p></th>
            ...
         </tr>
        */
        
        var html = "<tr>"
        
        // add <th> for each heading
        for definition in rowDefinitions  {
            let th = "<th align=\'\(definition.alignment)\' style=\'min-height:20px; min-width:\(definition.width); border-bottom:2px double black;\'><p>\(definition.title)</p></th>"
            html.append(th)
        }
        
        // close row tag
        html.append("</tr>")
        
        return html
    }
    
    
    func htmlForGroupHeader(route: Route, date: Date, colspan: Int) -> String {
        return "<tr style=\'border-bottom:2px solid black\'><td style=\'min-height:50px; border-bottom:1px solid black;\' colspan=\(colspan)><b>\(route.name ?? "Unknown Route") - \(date.toString(from: Styles.DATE_FORMAT_LONG))</b></br></td></tr>"
    }
    
    func htmlForRow(rowDefinitions: [RowDefinition<Visit>], visit: Visit) -> String {
        
        var html = "<tr>"
        let rowFormat = "<td align=\'%@\' style=\'min-width:%dpx; border-bottom:1px solid black;\'>%@</td>"
        
        for definition in self.rowDefinitions {
            html.append(String(format: rowFormat, definition.alignment, definition.width, definition.value(visit)))
        }
        
        html.append("</tr>")
        return html
    }
}
