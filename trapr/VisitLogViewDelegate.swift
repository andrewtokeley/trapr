//
//  VisitLogDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol VisitLogViewDelegate {
    func visitLogViewDidScroll(_ visitLogView: VisitLogView, scrollView: UIScrollView)
}

protocol VisitLogDelegate {
    func didSelectToRemoveVisit()
    func didSelectToCreateNewVisit()
}

