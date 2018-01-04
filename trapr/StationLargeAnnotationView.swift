//
//  StationMapAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class StationLargeAnnotationView: MKPinAnnotationView, StationAnnotationView {

    private var stationMapAnnotation: StationMapAnnotation?
    
    override var annotation: MKAnnotation? {
        willSet {
    
            stationMapAnnotation = newValue as? StationMapAnnotation
            guard stationMapAnnotation != nil else { return }
            
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            pinTintColor = stationMapAnnotation!.highlighted ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
            
            if let title = stationMapAnnotation!.title {
                self.label.text = title
            }

        }
    }
    var state: HighlightState {
        return self.stationMapAnnotation!.highlighted ? .highlighted : .unhighlighted
    }
    
    var station: Station {
        return self.stationMapAnnotation!.station
    }

    func toggleState() {
        if let _ = stationMapAnnotation {
            print("toggle")
            // toggle highlighted state
            self.stationMapAnnotation!.highlighted = !self.stationMapAnnotation!.highlighted
            
            pinTintColor = stationMapAnnotation!.highlighted ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
        }
    }
    
    //MARK: - Subviews
    
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
    
    // MARK: - Initialisation
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
