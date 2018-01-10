//
//  StationSmallAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class StationCircleAnnotationView: StationAnnotationView {
    
//    private var stationMapAnnotation: StationMapAnnotation?
//    
//    var radius: Int {
//        return 18
//    }
//    
//    var showInnerText: Bool {
//        return true
//    }
//
//    var showTitle: Bool {
//        return true
//    }
//    
//    override var annotation: MKAnnotation? {
//        willSet {
//            
//            stationMapAnnotation = newValue as? StationMapAnnotation
//            guard stationMapAnnotation != nil else { return }
//            
//            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            
//            self.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
//            self.backgroundColor = UIColor.clear
//            
//            if showTitle {
//                self.titleLabel.text = stationMapAnnotation!.title
//            }
//            
//            if showInnerText {
//                self.setInnerText(text: stationMapAnnotation!.innerText)
//            }
//        }
//    }
//
////    var state: HighlightState {
////        return (self.stationMapAnnotation!.highlighted ?? false) ? .highlighted : .unhighlighted
////    }
//    
////    var station: Station {
////        return self.stationMapAnnotation!.station
////    }
//    
////    func toggleState() {
////        if let _ = stationMapAnnotation {
////            self.stationMapAnnotation!.highlighted = !self.stationMapAnnotation!.highlighted
////            self.setNeedsDisplay()
////        }
////    }
//    
//    func setInnerText(text: String?) {
//        self.innerLabel.text = text
//    }
//    
//    func setColour(colour: UIColor) {
//        //self.stationMapAnnotation!.highlighted = !self.stationMapAnnotation!.highlighted
//        //            self.setNeedsDisplay()
//    }
//    
//    //MARK: - Subviews
//    
//    var innerLabel: UILabel = {
//        
//        let WIDTH:CGFloat = 18 * 2 - 8
//        
//        let label = UILabel()
//        label.adjustsFontSizeToFitWidth = true
//        label.textColor = UIColor.white
//        label.textAlignment = .center
//        label.frame = CGRect(x: 4, y: -2, width: WIDTH, height: LayoutDimensions.inputHeight)
//        
//        return label
//    }()
//    
//    var titleLabel: UILabel = {
//        
//        let WIDTH:CGFloat = 18 * 2
//        
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.textAlignment = .center
//        label.frame = CGRect(x: 0, y: 18 + 2, width: WIDTH, height: LayoutDimensions.inputHeight)
//        label.font = UIFont.trpLabelSmall
//        
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowOffset = CGSize.zero
//        label.layer.shadowOpacity = 0.9
//        label.layer.shadowRadius = 6
//        label.layer.masksToBounds = false
//        
//        return label
//    }()
//    
//    override func draw(_ rect: CGRect) {
//        
////        let circleRect = CGRect(x: rect.origin.x + 2, y: rect.origin.y + 2, width: rect.width - 4, height: rect.height - 4)
////        let path = UIBezierPath(ovalIn: circleRect)
////        if let highlight = self.stationMapAnnotation?.highlighted {
////            let fillColor = highlight ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
////            fillColor.setFill()
////            UIColor.white.setStroke()
////            path.lineWidth = 2
////            path.stroke()
////            path.fill()
////        }
//    }
//    
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        
//        if showTitle { self.addSubview(self.titleLabel) }
//        if showInnerText { self.addSubview(self.innerLabel) }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
