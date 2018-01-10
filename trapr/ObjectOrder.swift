//
//  ObjectOrder.swift
//  trapr
//
//  Created by Andrew Tokeley on 9/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class ObjectOrder<T: Hashable> {
    
    private var objects = [T: Int]()
    
    init() {
        
    }
    
    /**
    Take the order of the objects in the array as the initial order
    */
    convenience init(objects: [T]) {
        self.init()
        for object in objects {
            let _ = add(object)
        }
    }
    
    /**
     Adds the object to the collection giving it the most appropriate default order. Items are added to the first available gap in the order sequence, or at the end if no gaps exist.
     
     Note if you add an object that already exists, the function will do nothing, and simply return the current order.
    */
    func add(_ object: T) -> Int {
        
        if let index = objects[object] {
            return index
        } else {
            let index = nextIndex()
            objects[object] = index
            return index
        }
    }
    
    func orderOf(_ object: T) -> Int? {
        return objects[object]
    }
    
    func reverse() {
        for object in objects {
            objects[object.key] = (self.count - 1) - object.value
        }
    }
    
    func remove(_ object: T) {
        objects.removeValue(forKey: object)
    }

    func removeAll() {
        objects = [T: Int]()
    }
    
    var count: Int {
        return objects.count
    }
    
    var orderedObjects: [T] {
        return objects.sorted(by: { $0.value < $1.value }).map({ $0.key })
    }
    
    private var orderedIndexes: [Int] {
        return objects.sorted(by: { $0.value < $1.value }).map({ $0.value })
    }
    
    private func nextIndex() -> Int {
        
        let indexes = self.orderedIndexes
        
        // if there are no indexes return 0, if there are one indexes, return 1
        if indexes.count <= 1 { return indexes.count }
        
        // if the first index isn't 0, the next index must be
        if indexes[0] != 0 { return 0 }
        
        // find the first gap in the sequence
        for i in 0...indexes.count - 2 {
            
            // check whether the index at position i is one less than the next index
            if indexes[i] + 1 != indexes[i + 1] {
                return indexes[i] + 1
            }
        }

        // no gaps, return the next index
        return indexes.count
    }
    
}
