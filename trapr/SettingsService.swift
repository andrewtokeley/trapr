//
//  ProfileService.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class SettingsService: RealmService, SettingsServiceInterface {
    
    func getSettings() -> Settings {
    
        var settings = realm.objects(Settings.self).first
        
        if settings == nil {
            
            // Createa new Settings record
            settings = Settings()
            addOrUpdate(settings: settings!)
        }

        updateVersions(settings: settings!)
        
        return settings!
    }
    
    private func updateVersions(settings: Settings) {
        try! realm.write {
            // always make sure the version numbers are up to date
            let dictionary = Bundle.main.infoDictionary!
            let version = dictionary["CFBundleShortVersionString"] as? String
            let build = dictionary["CFBundleVersion"] as? String
            
            settings.appVersion = "\(version ?? "0").\(build ?? "0")"
            settings.realmVersion = String(ServiceFactory.sharedInstance.realm.configuration.schemaVersion)
        }
    }
    
    func addOrUpdate(settings: Settings) {
        try! realm.write {
            realm.add(settings, update: true)
        }
    }
    
}
