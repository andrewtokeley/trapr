//
//  StaticSection.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 4/09/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class StaticRow {
    var cell: UITableViewCell
    var height: CGFloat? = nil
    var isVisible: Bool = true
    
    init(_ cell: UITableViewCell) {
        self.cell = cell
    }
    
    init(_ cell: UITableViewCell, _ height: CGFloat) {
        self.cell = cell
        self.height = height
    }
}

class StaticSection {
    var title: String?
    var rows = [StaticRow]()
    var isVisible: Bool = true
    var footerText: String?
    
    init(_ title: String, _ rows: [StaticRow]) {
        self.title = title
        self.rows = rows
    }
    
    init(_ title: String, _ footerText: String, _ rows: [StaticRow]) {
        self.title = title
        self.rows = rows
        self.footerText = footerText
    }
}
