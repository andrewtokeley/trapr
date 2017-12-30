//
//  StationMapAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class StationLargeAnnotationView: MKPinAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
    
            guard let stationMapAnnotation = newValue as? StationMapAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            pinTintColor = stationMapAnnotation.highlighted ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
            
            if let title = stationMapAnnotation.title {
                self.label.text = title
            }

        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.frame = CGRect(x: 0, y: 20, width: 100, height: LayoutDimensions.inputHeight)
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 6
        label.layer.masksToBounds = false
        
        label.font = UIFont.trpLabelSmall
        return label
    }()
}
