//
//  ListPickerDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol ListPickerDelegate {
    
	// must implement
    func listPicker(_ listPicker: ListPickerView, itemTextAtRow: Int) -> String
    func listPicker(_ listPicker: ListPickerView, didSelectItemAtRow: Int)
    func listPicker(title listPicker: ListPickerView) -> String
    func listPicker(headerText listPicker: ListPickerView) -> String
    func listPicker(numberOfRows listPicker: ListPickerView) -> Int
    
    // optional
    func listPicker(_ listPicker: ListPickerView, itemDetailAtRow: Int) -> String?
}
    
    //MARK: - Default implementations for optional methods
    extension ListPickerDelegate {
        
        func listPicker(_ listPicker: ListPickerView, itemDetailAtRow: Int) -> String? {
            return nil
        }
}
