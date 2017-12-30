//
//  TrapServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol TrapServiceInterface: RealmServiceInterface {
    
    //func getLurePercentageVarianceFromAverageBalance(trap: Trap, asAtDate: Date) -> Double
    func getLureBalance(trap: Trap, asAtDate: Date) -> Int
}
