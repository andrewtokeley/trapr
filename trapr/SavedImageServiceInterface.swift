//
//  SavedImageServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Photos

protocol SavedImageServiceInterface {
    
    /**
    Adds or updates a saved image record based on a source photo image URL. If the image is deemed to have already been saved locally (based on uniqueKey) an existing SavedImage record is returned, otherwise, a new SavedImage record will be created and returned.
    */
    func addOrUpdateSavedImage(asset: PHAsset, completion: ((SavedImage?) -> Void)?)
    
}
