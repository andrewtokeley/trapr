//
//  StationSmallAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class StationSmallAnnotationView: MKAnnotationView {
    
    private var stationMapAnnotation: StationMapAnnotation?
    
    override var annotation: MKAnnotation? {
        willSet {
            
            stationMapAnnotation = newValue as? StationMapAnnotation
            guard stationMapAnnotation != nil else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            self.backgroundColor = UIColor.clear
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
