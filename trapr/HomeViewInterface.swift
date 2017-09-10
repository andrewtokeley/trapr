//
//  HomeViewInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol HomeViewInterface {
    
    func displayRecentVisits(visits: [VisitSummary]?)
    func setTitle(title: String)
    
}
