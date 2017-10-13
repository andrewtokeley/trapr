//
//  DatePickerDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 12/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerDelegate {
    func displayMode(datePicker: DatePickerViewApi) -> UIDatePickerMode
    func showTodayButton(datePicker: DatePickerViewApi) -> Bool
    func datePicker(datePicker: DatePickerViewApi, didSelectDate: Date)
}
