//
//  TrapService.swift
//  trapr
//
//  Created by Andrew Tokeley on 24/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

fileprivate struct LureTotals {
    var added: Int = 0
    var removed: Int = 0
    var eaten: Int = 0
}

class TrapService: RealmService, TrapServiceInterface {
    
    func setArchiveState(trap: Trap, archive: Bool) {
        try! realm.write {
            trap.archive = archive
        }
    }
    
    func deleteTrap(trap: Trap) {
        try! realm.write {
            realm.delete(trap)
        }
    }
    
    func getLureBalance(trap: Trap, asAtDate: Date) -> Int {
        
        var totals = LureTotals()
        
        // get all the visits for the trap
        let visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedBetween: Date().add(0, 0, -100).dayStart(), dateEnd: asAtDate.dayEnd(), trap: trap)
        
        // total up how many added, eaten, removed
        for visit in visits {
            totals.added += visit.baitAdded
            totals.removed += visit.baitRemoved
            totals.eaten += visit.baitEaten
        }
        
        return totals.added - (totals.eaten + totals.removed)
    }
}
