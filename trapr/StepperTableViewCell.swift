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
    //private var actionClosure: ((UIButton) -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        actionButton.layer.cornerRadius = 5
        actionButton.backgroundColor = .trpStepperBackground
        
        actionButton.setTitleColor(.trpHighlightColor, for: .normal)
        actionButton.setTitleColor(.lightGray, for: .disabled)
        actionButton.addTarget(self, action: #selector(actionButtonClicked(sender:)), for: .touchUpInside)
        
        // Bug that you need to set the images for tintColor and backgroundColor to work
        stepper.setBackgroundImage(stepper.backgroundImage(for: .normal), for: .normal)
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        stepper.layer.cornerRadius = 5
        stepper.backgroundColor = .trpStepperBackground
        stepper.tintColor = .trpHighlightColor
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
            actionButton.isEnabled = stepper.value < stepper.maximumValue
        }
    }
    
    func setMax(maximum: Int) {
        stepper.maximumValue = Double(maximum)
    }
    
    @objc func actionButtonClicked(sender: UIButton) {
        stepper.value = stepper.maximumValue
        countLabel.text = String(Int(stepper.maximumValue))
        delegate?.stepper(self, valueChanged: Int(stepper.maximumValue))
    }
    
    @IBAction func stepperClicked(sender: UIStepper) {
        actionButton.isEnabled = stepper.value < stepper.maximumValue
        delegate?.stepper(self, valueChanged: Int(sender.value))
        countLabel.text = String(Int(sender.value))
    }
}
