//
//  CachePrimerServiceInterface.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 20/12/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol CachePrimerServiceInterface {
    
    /**
     Loads core application data from server into local cache to enable offline use.
     
     Core data includes;
     - Routes
     - Species
     - Lures
     - TrapTypes
     - Traplines
     - Stations
     - Regions
     
     - parameters:
        - progress: closure to report progress of service call. The first parameter is a value between 0 and 1, where 1 indicates the service has completed priming the cache. The second parameter contains a description of progress suitable to be displayed to the user. The final parameter returns whether the process has completed (which in some cases isn't when the first parameter is 1)
    */
    func primeCache(progress: ((Double, String, Bool) -> Void)?)
    
    /**
     Returns, via the closure, whether the cache is already primed. If true, basic lookup and station data is present and the app will function fine, even if offline. If false, the cache must be primed before the app run.
     
     - parameters:
        - completion: closure where parameter is a flag indicating whether the cache has been primed already.
     
    */
    func cachePrimed(completion: ((Bool) -> Void)?)
}
