//
//  HomeWireframeInput.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol HomeWireframeInput {

    func presentView(in window: UIWindow)
    func presentVisitModule(dateOfVisit: Date)
}
