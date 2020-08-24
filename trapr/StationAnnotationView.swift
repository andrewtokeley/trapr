//
//  TogglableAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol StationAnnotationView: class {
    
    var innerText: String? { get set }
    var subText: String? { get set }
    var color: UIColor { get set }
    var borderColor: UIColor { get set }
    var radius: Int { get set }
}

extension StationAnnotationView {
    var radius: Int {
        set {
            // do nothing
        }
        get {
            return 0
        }
    }
    
    var borderColor: UIColor {
        set {
            
        }
        get {
            return .white
        }
    }
}
