//
//  ServiceFactory.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class ServiceFactory {
    static let sharedInstance = ServiceFactory()
    
    var visitService: VisitServiceInterface {
        return VisitServiceMock()
    }
}
