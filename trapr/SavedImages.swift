//
//  SavedImages.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class SavedImage: Object {

    // Primary key
    @objc dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /** Assumed to be a unique identifier for the sourced image. This is useful to check whether a user is selecting an image that's already been saved locally in the app's document directory.
    */
    @objc dynamic var sourceDateTimeStamp: String?
    
    @objc dynamic var imageName: String
    
}
