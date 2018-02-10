//
//  SavedImageService.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Photos

class SavedImageService: RealmService, SavedImageServiceInterface {
    
    func addOrUpdateSavedImage(asset: PHAsset, completion: ((SavedImage) -> Swift.Void)?) {
        
        // get the unique id of the asset
        let sourceId = uniqueIdentifier(asset: asset)
        
        // get the savedImage
        let savedImage = getOrCreateSavedImage(sourceId: sourceId)
        
        // make sure the file has been saved locally
        let savedImagePath = savedImage.imageUrl?.relativePath
        if savedImagePath != nil && FileManager.default.fileExists(atPath: savedImagePath!) {
            
            // file exists, we're good
            completion?(savedImage)
            
        } else {
        
            // the file doesn't exist on disk - typically because we've selected a photo that's never been selected before

            // create a unique name - doesn't really matter, just a convenience
            let imageName = UUID().uuidString
            
            // save the asset locally
            let localPath = ServiceFactory.sharedInstance.settingsService.getSettings().documentDirectory.appendingPathComponent(imageName).relativePath
            
            copyAsset(asset: asset, destinationUrlPath: localPath, completion: {
                
                // update the imageName on the savedImage, so we can find it next time
                try! self.realm.write {
                    savedImage.imageName = imageName
                }
                completion?(savedImage)
            })
        }
    }
    
    private func getOrCreateSavedImage(sourceId: String) -> SavedImage {
        
        var savedImage = realm.objects(SavedImage.self).filter(
            {
                (savedImage) -> Bool in
                    savedImage.id == sourceId
            }).first
    
        if savedImage == nil {
            
            // we need to record the existance of this savedImage in realm
            savedImage = SavedImage()
            savedImage!.id = sourceId
            
            // create a new record
            try! self.realm.write {
                self.realm.add(savedImage!)
            }
        }
        
        return savedImage!
    }
    
   
    private func uniqueIdentifier(asset: PHAsset) -> String {
        
        // use the creationdate+height+width of the asset as (hopefully!) unique. Not the end of the world if not, so relaxed
//        return asset.creationDate?.toString(from: "ddMMyyyyhhmmss").appending("\(asset.pixelHeight)\(asset.pixelWidth)") ?? UUID().uuidString
        return asset.localIdentifier
    }
    
    private func copyAsset(asset: PHAsset, destinationUrlPath: String, completion: (() -> Swift.Void)?) {
        //get the URL to the asset
        PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (data, dataUTI, orientation, info) in
            let result = FileManager.default.createFile(atPath: destinationUrlPath, contents: data, attributes: nil)
            print("filecreate \(result ? "succeeded" : "failed")")
            
            completion?()
        })
    }
    
}
