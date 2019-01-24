//
//  SavedImages.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class SavedImage {

    /**
    Unique identifier for the image. This will be a composit of createddate and size information as we can't rely on localIdentifier. The value of the id is set in SavedImageService
    */
    var id: String?
    
    /**
    Reference to the location of the saved image
    */
    var imageName: String?
    
    /**
     Fully qualified path to the image stored on the phone
    */
    var imageUrl: URL? {
        if let imageName = imageName {
            // document directory
//            let documentDirectory =
//            return documentDirectory.appendingPathComponent(imageName)
        }
        return nil
    }
}
