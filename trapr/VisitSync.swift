//
//  VisitSync.swift
//  trapr
//
//  Created by Andrew Tokeley on 4/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class VisitSync: Object {
    
    // Primary key
    @objc dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var route: Route?
    @objc dynamic var visitDateTime: Date = Date()
    @objc dynamic var syncDateTime: Date = Date()
    @objc dynamic var sentTo: String?
    
    convenience init(visitSummary: VisitSummary, syncDateTime: Date, sentTo: String?) {
        self.init()
        self.visitDateTime = visitSummary.dateOfVisit
        self.route = visitSummary.route
        self.syncDateTime = syncDateTime
        self.sentTo = sentTo
    }
}
