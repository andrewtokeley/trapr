//
//  BarChartDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 13/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

//struct BarIndexPath {
//    var bar: Int
//    var stack: Int
//}

protocol StackedBarChartDelegate {

    /**
     Returns the legend item data for a given label index.
     */
    func stackedBarChart(_ stackedBarChart: StackedBarChart, legendItemDataAtIndex index: Int) -> StackedBarChartLegendItemData?
    
    /**
     Returns the number of bars on the chart
     */
    func stackedBarChartNumberOfBars(_ stackedBarChart: StackedBarChart) -> Int
    
    /**
      Returns the number of maximum number of stacks a bar can have.
     
      Note that all bars have the same number of stacks, even if a stack value is zero.
     */
    func stackedBarChartNumberOfStacks(_ stackedBarChart: StackedBarChart) -> Int
    
    /**
     Returns the value of each stack for a given bar index.
     */
    func stackedBarChart(_ stackedBarChart: StackedBarChart, valuesAt barIndex: Int) -> [Double]
    
    /**
     Returns the label to present for a given bar index. Assumes the axis will be on the bottom of the chart.
     */
    func stackedBarChart(_ stackedBarChart: StackedBarChart, xLabelFor barIndex: Int) -> String?
    
    /**
     Returns the colour of the stack at given stack index.
     */
    func stackedBarChart(_ stackedBarChart: StackedBarChart, colourOfStack stackIndex: Int) -> UIColor?
    
    /**
     Returns the textual description of the stack for a given stack index.
     */
    func stackedBarChart(_ stackedBarChart: StackedBarChart, stackLabel stackIndex: Int) -> String?
    
}

extension StackedBarChartDelegate {
    func stackedBarChart(_ stackedBarChart: StackedBarChart, legendItemDataAtIndex index: Int) -> StackedBarChartLegendItemData? {
        return nil
    }
    
    func stackedBarChartNumberOfBars(_ stackedBarChart: StackedBarChart) -> Int {
        return 0
    }
    
    func stackedBarChartNumberOfStacks(_ stackedBarChart: StackedBarChart) -> Int {
        return 0
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, valuesAt barIndex: Int) -> [Double] {
        return [Double]()
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, xLabelFor barIndex: Int) -> String? {
        return nil
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, colourOfStack stackIndex: Int) -> UIColor? {
        return nil
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, stackLabel stackIndex: Int) -> String? {
        return nil
    }
}
