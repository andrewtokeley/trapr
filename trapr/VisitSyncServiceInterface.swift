//
//  VisitSyncServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 4/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//
import Foundation
import RealmSwift

protocol VisitSyncServiceInterface {
    
    /**
    Marks a VisitSummary as having been synchronised with server or emailed to a handler
     */
    func add(visitSync: VisitSync)
    
    /**
    Return the VisitSync records for the visitSummary. Typically there is either none or one sync per VisitSummary, however it is possible a VistSummary has been synced multiple times. If no sync has been performed nil will be returned.
    */
    func getVisitSyncs(visitSummary: VisitSummary) -> [VisitSync]?
    
}

