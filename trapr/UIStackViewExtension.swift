//
//  UIStackViewExtension.swift
//  trapr
//
//  Created by Andrew Tokeley on 23/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

    /**
     Fully removes all arrangedSubViews, including removing each from their superview
     */
    public func removeAllArrangedSubViews() {
        while self.arrangedSubviews.count > 0 {
            let subView = self.arrangedSubviews.first!
            self.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
}
