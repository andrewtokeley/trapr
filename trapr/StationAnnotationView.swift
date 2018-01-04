//
//  TogglableAnnotationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

enum HighlightState {
    case highlighted
    case unhighlighted
}

protocol StationAnnotationView {
    func toggleState()
    var state: HighlightState { get }
    var station: Station { get }
}
