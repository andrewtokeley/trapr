//
//  StaticTableViewDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 5/09/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

@objc protocol StaticTableViewDelegate {
    @objc optional func tableView(_ tableView: StaticTableView, didSelectRowAt indexPath: IndexPath)
}
