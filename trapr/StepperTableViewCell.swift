//
//  StepperTableViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley  on 26/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class StepperTableViewCell: UITableViewCell {

    var delegate: StepperTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func stepperClicked(sender: UIStepper) {
        
        delegate?.stepper(self, valueChanged: Int(sender.value))
        countLabel.text = String(Int(sender.value))
    }
}
