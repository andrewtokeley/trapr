//
//  HtmlServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol HtmlServiceInterface {

    func getVisitsAsHtmlTable(recordedOn date: Date, route: Route) -> String?
    
}
