//
//  TrapServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol TrapServiceInterface {
    
    func setArchiveState(trap: Trap, archive: Bool)
    func deleteTrap(trap: Trap)
    func getLureBalance(trap: Trap, asAtDate: Date) -> Int
    
}
