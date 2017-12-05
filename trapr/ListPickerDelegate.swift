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
    func listPickerTitle(_ listPicker: ListPickerView) -> String
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int
    
    // optional
    func listPickerHasChildListPicker(_ listPicker: ListPickerView) -> Bool
    func listPickerInitialMultiselectState(_ listPicker: ListPickerView) -> MultiselectOptions
    func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String?
    func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool
    
    func listPickerDidSelectNoSelection(_ listPicker: ListPickerView)
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int)
    func listPicker(_ listPicker: ListPickerView, didSelectMultipleItemsAt indexes: [Int])
}
    
    //MARK: - Default implementations for optional methods
    extension ListPickerDelegate {
    
        func listPickerDidSelectNoSelection(_ listPicker: ListPickerView) {
            // do nothing
        }
        
        func listPickerHasChildListPicker(_ listPicker: ListPickerView) -> Bool {
            return false
        }
        
        func listPickerInitialMultiselectState(_ listPicker: ListPickerView) -> MultiselectOptions {
            return .none
        }
        
        func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool {
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
