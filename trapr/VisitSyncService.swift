//
//  VisitSyncService.swift
//  trapr
//
//  Created by Andrew Tokeley on 4/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSyncService: RealmService, VisitSyncServiceInterface {
    
    func add(visitSync: VisitSync) {
        try! realm.write {
            realm.add(visitSync)
        }
    }
    
    func getVisitSyncs(visitSummary: VisitSummary) -> [VisitSync]? {
        return Array(realm.objects(VisitSync.self)).sorted(by: {
            $0.syncDateTime < $1.syncDateTime }, stable: true)
    }
    
}
