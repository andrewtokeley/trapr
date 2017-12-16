//
//  ProfileService.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class ProfileService: RealmService, ProfileServiceInterface {
    
    func addOrUpdate(profile: Profile) {
        try! realm.write {
            realm.add(profile, update: true)
        }
    }
    
}
