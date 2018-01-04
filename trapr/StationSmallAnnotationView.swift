//
//  StationSmallAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class StationSmallAnnotationView: MKAnnotationView, StationAnnotationView {
    
    private var stationMapAnnotation: StationMapAnnotation?
    
    internal var radius: Int {
        return 20
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            
            stationMapAnnotation = newValue as? StationMapAnnotation
            guard stationMapAnnotation != nil else { return }
            
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            self.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
            self.backgroundColor = UIColor.clear
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
            self.stationMapAnnotation!.highlighted = !self.stationMapAnnotation!.highlighted
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let circleRect = CGRect(x: rect.origin.x + 2, y: rect.origin.y + 2, width: rect.width - 4, height: rect.height - 4)
        let path = UIBezierPath(ovalIn: circleRect)
        if let highlight = self.stationMapAnnotation?.highlighted {
            let fillColor = highlight ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
            fillColor.setFill()
            UIColor.black.setStroke()
            path.lineWidth = 2
            path.stroke()
            path.fill()
        }
    }
}
