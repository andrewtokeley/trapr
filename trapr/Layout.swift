//
//  Layout.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

struct LayoutDimensions {
    
    /**
    Maximum width of left aligned labels in custom UITableViewCell
    */
    static let tableViewLabelWidth: CGFloat = 60
    
    /**
    Standard spacing between view elements
    */
    static let spacingMargin: CGFloat = 20
    
    /**
     Standard spacing between view elements
     */
    static let smallSpacingMargin: CGFloat = 10
    
    /**
    Standard text indentation from nearest edge
     */
    static let textIndentMargin: CGFloat = 15
    
    /**
    Standard height for UITextField, UILabels etc
    */
    static let inputHeight: CGFloat = 40
    
    /**
     Standard height for UITableViewCell
     */
    static let tableCellHeight: CGFloat = 44

    /**
     Standard height for UITableView section header
     */
    static let tableHeaderSectionHeight: CGFloat = 60

    /**
     Standard height for UITableView footer
     */
    static let tableFooterSectionHeight: CGFloat = 20

    /**
     Large height for UITableView footer - useful for last section footer
     */
    static let tableFooterSectionHeightLarge: CGFloat = 100

}
