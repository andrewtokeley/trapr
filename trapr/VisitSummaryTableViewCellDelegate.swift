//
//  VisitSummaryTableViewCellDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 27/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol VisitSummaryTableViewCellDelegate {
    func visitSummaryTableViewCell(_ visitSummaryTableViewCell: VisitSummaryTableViewCell, didSelectVisitSummary visitSummary: VisitSummary)
}   
