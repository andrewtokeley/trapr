//
//  ArrayExtensions.swift
//  trapr
//
//  Created by Andrew Tokeley on 20/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
enum ArrayError: Error {
    case GeneralError
}

extension Array where Iterator.Element: BinaryFloatingPoint {
    
    struct RankResult {
        var rank: Int
        var isTied: Bool
    }
    
    func sum() -> Double {
        guard self.count > 0 else { return 0 }
        
        return Double(self.reduce(0, +))
    }
    
    func mean() -> Double? {
        guard self.count > 0 else { return nil }
        return sum() / Double(self.count)
    }
    
    func median() -> Double? {
        guard self.count > 0 else { return nil }
        
        let sorted = self.sorted()
        
        if count % 2 == 0 {
            // even number
            return Double((sorted[count/2 - 1] + sorted[count/2])) / 2.0
        } else {
            // odd number, pick the middle one
            return Double(sorted[count/2])
        }
    }
    
    /**
     Returns the rank of the item at *index* within the array
     */
    func rank(index: Int, highestFirst: Bool = true) -> RankResult? {
        guard
            self.count > 0 &&
            index < count &&
            index >= 0
        else { return nil }
        
        let valueAtIndex = self[index]
        let sorted = self.sorted()
        
        if let sortedIndex = sorted.firstIndex(where: { $0 == valueAtIndex }) {
            let tied = (sorted.filter { $0 == valueAtIndex }).count > 1
            return RankResult(rank: sortedIndex + 1, isTied: tied)
        }
        return nil
    }
    
    /**
     Returns the rank of the given value within the array. If the value doesn't equal the value of one of the elements of the array the function returns nil. A rank of 1 means the value is the lowest number in the array.
     */
    func rank(value: Iterator.Element, highestFirst: Bool = true) -> RankResult? {
        guard self.count > 0 else { return nil }

        var sorted: [Element]
        if highestFirst {
            sorted = self.sorted(by: >)
        } else {
            sorted = self.sorted(by: <)
        }
        
        if let sortedIndex = sorted.firstIndex(where: { $0 == value }) {
            let tied = (sorted.filter { $0 == value }).count > 1
            return RankResult(rank: sortedIndex + 1, isTied: tied)
        }
        return nil
    }
    
    func lowerQuartile() -> Double? {
        guard self.count > 0 else { return nil }
        
        if let median = self.median() {
            let lowerHalf = self.filter({ Double($0) < median })
            return lowerHalf.median()
        }
        return nil
    }
    
    func upperQuartile() -> Double? {
        guard self.count > 0 else { return nil }
        
        if let median = self.median() {
            let upperHalf = self.filter({ Double($0) > median })
            return upperHalf.median()
        }
        return nil
    }
    
    var quartiles: Quartiles {
        return Quartiles(
            lowerQuartile() ?? 0,
            median() ?? 0,
            upperQuartile() ?? 0
        )
    }
    
}
