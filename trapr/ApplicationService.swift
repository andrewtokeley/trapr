//
//  ApplicationService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 22/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class ApplicationService: Service, ApplicationServiceInterface {
    
    func deleteAllData() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
