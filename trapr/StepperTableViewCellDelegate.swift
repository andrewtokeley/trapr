//
//  StepperTableViewCellDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 26/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol StepperTableViewCellDelegate {
    func stepper(_ stepper: StepperTableViewCell, valueChanged: Int)
}
