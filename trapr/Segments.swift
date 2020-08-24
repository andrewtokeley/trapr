//
//  HeatMapRange.swift
//  trapr
//
//  Created by Andrew Tokeley on 7/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

struct Segment {
    var colour: UIColor
    var range: Range<Int>
}

extension Range where Bound == Int {

    func description() -> String {
        let upperBoundDescription = self.isOpenEnded ? "+" : " - \(self.upperBound)"
        return "\(self.lowerBound)\(upperBoundDescription)"
    }
    
    var isOpenEnded: Bool {
        return self.upperBound == Int.max
    }
}

class SegmentCollection {
    
    var openEnded: Bool = false
    
    var segments = [Segment]()
    
//    convenience init(start: Int, segmentLength: Int, numberOfSegments: Int, openEnded: Bool = false) {
//        self.init(start: Double(start), segmentLength: Double(segmentLength), numberOfSegments: numberOfSegments, openEnded: openEnded)
//        self.defaultRoundingPrecision = 0
//    }
    
    /**
     Create instance directly from an array of `Segment` instances
     */
    init(segments: [Segment]) {
        self.segments = segments
    }
    
    /**
     Create instance assuming the first segment starts at a given value (usually 0) and each segment is an equal length. The last segment can be specified as open ended.
     */
    init(start: Int, segmentLength: Int, numberOfSegments: Int = 7, openEnded: Bool = false) {
        
        var index = 0
        let end = segmentLength * numberOfSegments
        for lowerBound in stride(from: start, to: end, by: segmentLength) {
            
            let segmentColour = UIColor.trpHeatColour(heatValue: index)
            // Check if this is the last range in whether it should be open ended
            if openEnded && lowerBound >= end {
                self.segments.append(Segment(colour: segmentColour, range: lowerBound..<Int.max))
            } else {
                self.segments.append(Segment(colour: segmentColour, range: lowerBound..<(lowerBound + segmentLength)))
            }
            index += 1
        }
        self.openEnded = openEnded
    }
    
    var count: Int {
        return segments.count
    }
    
    subscript(index: Int) -> Segment {
        get {
            assert(index < segments.count, "Index out of range")
            return segments[index]
        }
    }
    
    var first: Segment? {
        return segments.first
    }
    
    var last: Segment? {
        return segments.last
    }
}
