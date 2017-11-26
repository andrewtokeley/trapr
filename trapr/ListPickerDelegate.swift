//
//  ListPickerDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol ListPickerDelegate {
    
	// must implement
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String
    func listPicker(title listPicker: ListPickerView) -> String
    func listPicker(headerText listPicker: ListPickerView) -> String
    func listPicker(numberOfRows listPicker: ListPickerView) -> Int
    
    // optional
    func listPicker(hasChildListPicker listPicker: ListPickerView) -> Bool
    func listPicker(initialMultiselectState listPicker: ListPickerView) -> MultiselectOptions
    func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String?
    func listPicker(_ listPicker: ListPickerView, isInitiallySelected index: Int) -> Bool
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int)
    func listPicker(_ listPicker: ListPickerView, didSelectMultipleItemsAt indexes: [Int])
}
    
    //MARK: - Default implementations for optional methods
    extension ListPickerDelegate {
    
        func listPicker(hasChildListPicker listPicker: ListPickerView) -> Bool {
            return false
        }
        
        func listPicker(initialMultiselectState listPicker: ListPickerView) -> MultiselectOptions {
            return .none
        }
        
        func listPicker(_ listPicker: ListPickerView, isInitiallySelected index: Int) -> Bool {
            return false
        }
        
        func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
            // do nothing
        }
        
        func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String? {
            return nil
        }
        
        func listPicker(_ listPicker: ListPickerView, didSelectMultipleItemsAt indexes: [Int]) {
            // do nothing
        }
}
