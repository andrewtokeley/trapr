//
//  VerticallyCentredTextView.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class VerticallyCentredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
