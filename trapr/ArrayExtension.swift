//
//  ArrayExtension.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 13/04/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

extension Array {
    func grouped<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
}
