//
//  UIImageExtention.swift
//  trapr
//
//  Created by Andrew Tokeley on 23/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{

    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }

    
    func changeColor(_ color: UIColor) -> UIImage?
    {
        let size = self.size
        
        UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
        UIColor.white.setFill()
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsGetCurrentContext()?.fill(rect)
        self.draw(in: rect)
        let compositedMaskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        var unscaledSize = size
        unscaledSize.width *= self.scale;
        unscaledSize.height *= self.scale;
        
        UIGraphicsBeginImageContext(unscaledSize)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        
        let unscaledRect = CGRect(x: 0, y: 0, width: unscaledSize.width, height: unscaledSize.height)
        context?.fill(unscaledRect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let compositedMaskImageRef = compositedMaskImage?.cgImage
        let mask = CGImage(
            maskWidth: Int(unscaledSize.width),
            height: Int(unscaledSize.height),
            bitsPerComponent: (compositedMaskImageRef?.bitsPerComponent)!,
            bitsPerPixel: (compositedMaskImageRef?.bitsPerPixel)!,
            bytesPerRow: (compositedMaskImageRef?.bytesPerRow)!,
            provider: (compositedMaskImageRef?.dataProvider!)!,
            decode: nil,
            shouldInterpolate: false
        );
        
        let masked = colorImage?.cgImage?.masking(mask!)
        return UIImage(cgImage:masked!, scale:(compositedMaskImage?.scale)!, orientation:UIImageOrientation.up)
    }
    
}
