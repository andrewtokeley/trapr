//
//  ProfileServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol SettingsServiceInterface: RealmServiceInterface {
    func getSettings() -> Settings
    func addOrUpdate(settings: Settings)
}
