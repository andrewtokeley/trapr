//
//  VisitSummariesStatistics.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/09/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

struct VisitSummariesStatistics {
    
    /**
     The average time across all visits. Visits are excluded if they were less than 120 seconds, as these are deemed to be outliers, likely added to initialise a trapline.
     */
    var averageTimeTaken: TimeInterval = 0
    
    /**
     The fastest time across all visits. Visits are excluded if they were less than 120 seconds, as these are deemed to be outliers, likely added to initialise a trapline.
     */
    var fastestTimeTaken: TimeInterval = 0
    
}
