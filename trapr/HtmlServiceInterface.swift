//
//  HtmlServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol HtmlServiceInterface {

    /// Returns, via the closure, a well formed HTML fragment that contains a table of the visit results.
    func getVisitsAsHtml(recordedOn date: Date, route: _Route, completion: ((String?) -> Void)?)
    
    //func getVisitsAsHtml(recordedOn date: Date, route: Route) -> String?
    
}
