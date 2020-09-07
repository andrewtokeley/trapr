//
//  BarChartViewEx.swift
//  trapr
//
//  Created by Andrew Tokeley on 13/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Charts

class BarChartViewEx: BarChartView {
    
    public struct BarChartDataRaw {
        var yValues: [[Double]]
        var stackLabels: [String]
        var stackColours: [UIColor]
        
        /**
         Reorders the elements of yValue, stackLabel and stackColour according to the orderedStackLabels parameter.
         */
        mutating func reorder(orderedStackLabels: [String]) {
            
            // Create an array of indexes for the reordering, e.g. [3, 0, 1, 2] means the first elements of each array should be moved to index 3...
            var unmatchedIndex = orderedStackLabels.count
            let offsets = stackLabels.map({ (stack) -> Int in
                if let index = orderedStackLabels.firstIndex(of: stack) {
                    return index
                } else {
                    unmatchedIndex -= 1
                    return unmatchedIndex
                }
            })
            
            yValues = offsets.map { yValues[$0] }
            stackLabels = offsets.map { stackLabels[$0] }
            stackColours = offsets.map { stackColours[$0] }
        }
    }
    
    func drawChart(rawData: BarChartDataRaw) {
        
        guard rawData.yValues.count > 0 && rawData.yValues.first!.count > 0 && rawData.stackLabels.count > 0 else { return }

        let numberOfBars = rawData.yValues.count
        
        // Dataset
        var values = [BarChartDataEntry]()
        for barIndex in 0...numberOfBars - 1 {
            let yValues = rawData.yValues[barIndex]
            values.append(BarChartDataEntry(x: Double(barIndex), yValues: yValues))
        }
        let dataSet = BarChartDataSet(entries: values, label: nil)
        
        // Stack colors and labels
        if rawData.stackLabels.count > 1 {
            dataSet.stackLabels = rawData.stackLabels
        } else {
            dataSet.label = rawData.stackLabels.first
        }
        
        var colors = [NSUIColor]()
        for i in 0...rawData.stackLabels.count - 1 {
            if i < rawData.stackColours.count {
                colors.append(rawData.stackColours[i])
            } else {
                colors.append(UIColor.red)
            }
        }
        dataSet.setColors(colors, alpha: 1)
        
        let data = BarChartData(dataSet: dataSet)
        self.data = data

        // could get from delegate but always going to be the same in this app!
        data.barWidth = 0.3
        data.setDrawValues(false)
    }
}

//extension BarChartViewEx: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return dataSource!.chart(self, xLabelFor: Int(value), axis: axis)
//    }
//}

