//
//  RouteCollectionViewCellDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 23/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol RouteCollectionViewCellDelegate {
    func routeCollectionViewCell(_ routeCollectionViewCell: RouteCollectionViewCell, didSelectActionWith title: String)
    func routeCollectionViewCell(_ routeCollectionViewCell: RouteCollectionViewCell, actionTextAt index: Int) -> String?
    func routeCollectionViewCell(numberOfActionsFor routeCollectionViewCell: RouteCollectionViewCell) -> Int
    func routeCollectionViewCell(hostingViewControllerFor routeCollectionViewCell: RouteCollectionViewCell) -> UIViewController
}
