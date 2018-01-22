//
//  StationMarkerAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class StationMarkerAnnotationView: MKMarkerAnnotationView, StationAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // hide the pin image for now
        self.glyphImage = UIImage()
        self.glyphTintColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var subText: String? {
        didSet {
            self.titleVisibility = (subText != nil) ? .visible : .hidden
        }
    }
    
    var innerText: String? {
        didSet {
            self.glyphText = innerText
            
        }
        
    }
    
    var color: UIColor = UIColor.red {
        didSet {
            self.markerTintColor = color
        }
    }
    
}
