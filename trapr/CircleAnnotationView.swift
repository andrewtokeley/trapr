//
//  CircleAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

class CircleAnnotationView: MKAnnotationView, StationAnnotationView {
    
    private var stationMapAnnotation: StationMapAnnotation?
    private var titleLabelCreated: Bool = false
    private var innerTextLabelCreated: Bool = false
    
    var color: UIColor = UIColor.blue {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var borderColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var  subText: String? = nil {
        didSet {
            // don't unnecessarily create the UILabel if it's not needed
            if subText != nil || titleLabelCreated {
                titleLabel.text = subText
            }
        }
    }
    
    var innerText: String? = nil {
        didSet {
            // don't unnecessarily create the UILabel if it's not needed
            if innerText != nil || innerTextLabelCreated {
                innerLabel.text = innerText
            }
        }
    }
    
    var radius: Int = 10 {
        didSet {
            // resize the entire view's frame
            self.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
            
            // make sure the constraints are reapplied
            self.layoutIfNeeded()
        }
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            
            // this propery is set whenever a new view is created by the map control
            // Use it to configure the view
            
            // must be a station annotation
            stationMapAnnotation = newValue as? StationMapAnnotation
            guard stationMapAnnotation != nil else { return }
            
            // how should the callout appear
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            self.backgroundColor = UIColor.clear
            
        }
    }
    
    //MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "circle"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var innerLabel: UILabel = {
        self.innerTextLabelCreated = true
        
        let label = UILabel()
        label.font = UIFont.trpLabelSmall
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        self.addSubview(label)
        label.autoCenterInSuperview()
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        self.titleLabelCreated = true
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.trpLabelSmall
        label.dropShadow()
        
        // the title is positioned below the main frame, so don't clip it
        label.clipsToBounds = false
        
        self.addSubview(label)
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(.top, to: .bottom, of: self)
        
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // set default frame size
        self.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let BORDER_WIDTH: CGFloat = 2
        
        // make the circle slightly smaller to allow for border
        let circleRect = CGRect(x: rect.origin.x + BORDER_WIDTH, y: rect.origin.y + BORDER_WIDTH, width: rect.width - BORDER_WIDTH * 2, height: rect.height - BORDER_WIDTH * 2)
        let path = UIBezierPath(ovalIn: circleRect)
 
        color.setFill()
        
        borderColor.setStroke()
        path.lineWidth = BORDER_WIDTH
        path.stroke()
        path.fill()
        
    }
    
}
