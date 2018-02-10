//
//  SavedImages.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift
import Photos

class SavedImage: Object {

    /**
    Unique identifier for the image. This will be a composit of createddate and size information as we can't rely on localIdentifier. The value of the id is set in SavedImageService
    */
    @objc dynamic var id: String?
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
    Reference to the location of the saved image
    */
    @objc dynamic var imageName: String?
    
    var imageUrl: URL? {
        if let name = imageName {
            let settings = ServiceFactory.sharedInstance.settingsService.getSettings()
            return settings.documentDirectory.appendingPathComponent(name)
        }
        return nil
    }
    
}
