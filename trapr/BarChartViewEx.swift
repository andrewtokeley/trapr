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
    
    func buildData(yValues: [[Double]], stackLabels: [String], stackColors: [UIColor]) {
        
        guard yValues.count > 0 && yValues.first!.count > 0 && stackLabels.count > 0 else { return }

        let numberOfBars = yValues.count
        
        // Dataset
        var values = [BarChartDataEntry]()
        for barIndex in 0...numberOfBars - 1 {
            let yValues = yValues[barIndex]
            values.append(BarChartDataEntry(x: Double(barIndex), yValues: yValues))
        }
        let dataSet = BarChartDataSet(values: values, label: nil)
        
        // Stack colors and labels
        if stackLabels.count > 1 {
            dataSet.stackLabels = stackLabels
        } else {
            dataSet.label = stackLabels.first
        }
        
        var colors = [NSUIColor]()
        for i in 0...stackLabels.count - 1 {
            if i < stackColors.count {
                colors.append(stackColors[i])
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

