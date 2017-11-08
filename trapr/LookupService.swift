//
//  AnyLookupService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

//protocol LookupServiceInterface {
//    func createDefaults()
//    func getAll() -> [Any]
//    func get(code: String) -> Any?
//}

class LookupService<T: LookupObject>: Service {
    
    func createDefaults() {
        // do nothing, must be overriden for specific Type
    }
    
    func getAll() -> [T] {
        return Array(realm.objects(T.self).sorted(byKeyPath: "order"))
    }
    
    func get(code: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: code)
    }
}
