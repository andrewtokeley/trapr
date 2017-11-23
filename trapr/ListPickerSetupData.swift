//
//  ListPickerSetupData.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class ListPickerSetupData {
    
    var tag: Int = 0
    var allowMultiselect: Bool = false
    
    // If true, will be displayed as modal
    var embedInNavController: Bool = true
    
    var delegate: ListPickerDelegate?
    
    // supply if one lookup should navigate to another
    var childSetupData: ListPickerSetupData?
}
