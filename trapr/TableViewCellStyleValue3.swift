//
//  TableViewCellStyleValue3.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class TableViewCellStyleValue3: UITableViewCell {
    
    @IBOutlet weak var leftTextLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    
    override func awakeFromNib() {
        leftTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
        leftTextLabel.textColor = .black
        
        rightTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
        rightTextLabel.textColor = .trpTableViewCellValue1detail
        
        subtextLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtextLabel.textColor = .trpTextHighlight
        
    }
    
}
