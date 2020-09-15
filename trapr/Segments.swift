//
//  HeatMapRange.swift
//  trapr
//
//  Created by Andrew Tokeley on 7/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum SegmentCollectionError: Error {
    case invalidStartValue
}

struct Segment {
    var colour: UIColor
    var range: Range<Int>
    
    var zeroSegment: Bool {
        return range.lowerBound == 0 && range.upperBound == 1
    }
    
    var isOpenEnded: Bool {
        return range.upperBound == Int.max
    }
    
    var description: String {
        if zeroSegment {
            return "0"
        } else if isOpenEnded {
            return "\(range.lowerBound)+"
        } else {
            return "\(range.lowerBound) - \(range.upperBound)"
        }
    }
}

extension Range where Bound == Int {

    /**
     Returns a description of the range that can be displayed to a user. For example, 1 - 10, instead of the default description of `1..<10`
     */
    func description() -> String {
        let upperBoundDescription = self.isOpenEnded ? "+" : " - \(self.upperBound)"
        return "\(self.lowerBound)\(upperBoundDescription)"
    }
    
    var isOpenEnded: Bool {
        return self.upperBound == Int.max
    }
}

class SegmentCollection {
    
    //var openEnded: Bool = false
    
    var segments = [Segment]()
    
    /**
     Designated initializer. Creates instance directly from an array of `Segment` instances
     */
    init(segments: [Segment]) {
        self.segments = segments
    }
    
    convenience init(start: Int, numberOfSegments: Int, maxExpectedValue: Int, openEnded: Bool = false, includeZeroSegment: Bool = false) throws {
        
        let segmentLength: Int = maxExpectedValue/numberOfSegments + 1
        
        try self.init(start: start, segmentLength: segmentLength, numberOfSegments: numberOfSegments, openEnded: openEnded, includeZeroSegment: includeZeroSegment)
    }
    
    /**
     Create instance assuming the first segment starts at a given value and each segment is an equal length. The last segment can be specified as open ended.
     
     - Parameters:
        - start: the lower bound of the first segment
        - segmentLength: how big each segment is. For example, if a segment is 1 - 4, its length is 3.
        - numberOfSegments: how many equal segments to create, excluding the optional zero segment.
        - openEnded: if true, the last segment will be of infinite length
        - includeZeroSegment: if true an additional segment will be included at the beginning of the collection, representing values of zero.
     
     */
    convenience init(start: Int, segmentLength: Int, numberOfSegments: Int = 7, openEnded: Bool = false, includeZeroSegment: Bool = false) throws {
        
        // you can't start with a 0 - x, segment AND have a zero segment.
        guard !(start == 0 && includeZeroSegment) else { throw SegmentCollectionError.invalidStartValue }
            
        var result = [Segment]()
        
        for index in 0...numberOfSegments - 1 {
            
            let segmentColour = UIColor.trpHeatColour(segmentIndex: index)
            
            let lowerBound = start + index * segmentLength
            
            // Check if this is the last range in whether it should be open ended
            if openEnded && index == numberOfSegments - 1 {
                result.append(Segment(colour: segmentColour, range: lowerBound..<Int.max))
            } else {
                result.append(Segment(colour: segmentColour, range: lowerBound..<(lowerBound + segmentLength)))
            }
        }
        
        if includeZeroSegment {
            result.insert(Segment(colour: .trpHeatNoValue, range: 0..<1), at: 0)
        }
        
        self.init(segments: result)
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
