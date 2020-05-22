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
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        stepper.borderColor = .trpHighlightColor
        stepper.borderWidth = 1
        stepper.buttonsBackgroundColor = .white
        stepper.buttonsTextColor = .trpHighlightColor
        stepper.labelWidthWeight = 0.01
        stepper.cornerRadius = 5
        stepper.buttonsFont = UIFont(name: "AvenirNext-Regular", size: 30.0)!
    }
    
    func showActionButton(show: Bool) {
    }
    
    var countLabelValue:Int {
        get {
            if let value = countLabel.text {
                return Int(value) ?? 0
            } else {
                return 0
            }
        }
        set {
            countLabel.text = String(newValue)
            stepper.value = Double(newValue)
        }
    }
    
    func setMax(maximum: Int) {
        stepper.maximumValue = Double(maximum)
    }
    
    @IBAction func stepperValueChanged(_ sender: GMStepper) {
        delegate?.stepper(self, valueChanged: Int(sender.value))
        countLabel.text = String(Int(sender.value))
    }
    
//    @objc func actionButtonClicked(sender: UIButton) {
//        stepper.value = stepper.maximumValue
//        countLabel.text = String(Int(stepper.maximumValue))
//        delegate?.stepper(self, valueChanged: Int(stepper.maximumValue))
//    }
    
}
