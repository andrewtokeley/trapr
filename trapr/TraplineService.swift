//
//  TraplineService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class TraplineService: Service, TraplineServiceInterface {

    func add(trapline: Trapline) {
        try! realm.write {
            realm.add(trapline)
        }
    }
    
    func getTraplines() -> [Trapline]? {
        return Array(realm.objects(Trapline.self))
    }
    
    func getTrapline(code: String) -> Trapline? {
        return realm.objects(Trapline.self).filter({ (trapline) in return trapline.code == code }).first
    }
    
    func getRecentTraplines() -> [Trapline]? {
        let visitsInLast3Months = ServiceFactory.sharedInstance.visitService.getVisitSummaries(recordedBetween: Date().add(0, -3, 0), endDate: Date())
        
        var traplines = [Trapline]()
        for visitSummary in visitsInLast3Months {
            
            for trapline in visitSummary.traplines {
                if !traplines.contains(trapline) {
                    traplines.append(trapline)
                }
            }
        }
        
        return traplines
    }
}
