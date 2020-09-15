//
//  BarChartView.swift
//  trapr
//
//  Created by Andrew Tokeley on 11/09/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import Charts

/**
 Represents a bar chart (Charts.BarChartView) and optionally a legend.
 
 Note, the legend is not part of the one provided by `Charts.BarChartView` and is configurabe to show comparative data.
 
 To use this view, users must implement StackedBarChartDelegate to provide the data and configuration details.
 */
class StackedBarChart: UIView {
    
    private var showLegend: Bool = false
    
    public var delegate: StackedBarChartDelegate?
    
    // MARK: - Subviews
    
    private lazy var chart: BarChartView = {
        let chart = BarChartView()
        
        // don't show the default legend
        chart.legend.enabled = false
        
        chart.highlightPerTapEnabled = false
        chart.dragEnabled = false
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        
        // configure x axis
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = self
        xAxis.granularity = 1
        xAxis.labelCount = 12
        
        let yAxis = chart.getAxis(.left)
        yAxis.drawGridLinesEnabled = true
        yAxis.gridColor = .trpChartGridlines
        yAxis.granularity = 1
        
        chart.getAxis(.right).granularity = 1
        
        return chart
    }()
    
    private lazy var legendStrip: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 5
        return view
    }()
    
    private var legendStripItemView: StackedBarChartLegendItem {
        let view = StackedBarChartLegendItem(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(showLegend: Bool) {
        self.init(frame: CGRect.zero)
        self.showLegend = showLegend
        setupView()
    }
    
    func setupView() {
        addSubview(chart)
        if showLegend {
            addSubview(legendStrip)
        }
        setConstraints()
    }
    
    func setConstraints() {
        if showLegend {
            legendStrip.autoPinEdge(toSuperviewEdge: .left)
            legendStrip.autoPinEdge(toSuperviewEdge: .right)
            legendStrip.autoPinEdge(toSuperviewEdge: .bottom)
            legendStrip.autoSetDimension(.height, toSize: 60)
            
            chart.autoPinEdge(toSuperviewEdge: .left)
            chart.autoPinEdge(toSuperviewEdge: .right)
            chart.autoPinEdge(toSuperviewEdge: .top)
            chart.autoPinEdge(.bottom, to: .top, of: legendStrip, withOffset: -LayoutDimensions.smallSpacingMargin)
        } else {
            chart.autoPinEdgesToSuperviewEdges()
        }
    }
    
    /**
     Called to draw the chart. This should only be called once the delegate has been set.
     */
    public func drawChart() {
        
        guard let delegate = self.delegate else { return }
        
        self.chart.data = getBarChartDataSet()

        if showLegend {
            legendStrip.removeAllArrangedSubViews()
    
            let numberOfStacks = delegate.stackedBarChartNumberOfStacks(self)
            for i in 0...numberOfStacks - 1 {
                if let data = delegate.stackedBarChart(self, legendItemDataAtIndex: i) {
                    let view = self.legendStripItemView
                    view.updateDisplay(data: data)
                    legendStrip.addArrangedSubview(view)
                }
                
            }
        }
    }
    
    /**
     Gets the necessary data from the delegate to form the BarChartDataSet structure required by the underlying chart view
     */
    private func getBarChartDataSet() -> BarChartData? {
        
        guard let delegate = delegate else { return nil }
        
        let numberOfBars = delegate.stackedBarChartNumberOfBars(self)
        
        // Dataset
        var values = [BarChartDataEntry]()
        for barIndex in 0...numberOfBars - 1 {
            let yValues = delegate.stackedBarChart(self, valuesAt: barIndex)
            values.append(BarChartDataEntry(x: Double(barIndex), yValues: yValues))
        }
        let dataSet = BarChartDataSet(entries: values, label: nil)

        // Stack colors and labels
        let numberOfStacks = delegate.stackedBarChartNumberOfStacks(self)
        var stackLabels = [String]()
        for i in 0...numberOfStacks - 1 {
            stackLabels.append(delegate.stackedBarChart(self, stackLabel: i) ?? String(i))
        }
        if stackLabels.count > 1 {
            dataSet.stackLabels = stackLabels
        } else {
            dataSet.label = stackLabels.first
        }

        var colors = [NSUIColor]()
        for i in 0...numberOfStacks - 1 {
            colors.append(delegate.stackedBarChart(self, colourOfStack: i) ?? UIColor.black)
        }
        
        dataSet.setColors(colors, alpha: 1)

        let data = BarChartData(dataSet: dataSet)
        
        data.barWidth = 0.3
        
        // don't show values on bars
        data.setDrawValues(false)
        
        return data
    }
}

extension StackedBarChart: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return delegate?.stackedBarChart(self, xLabelFor: Int(value)) ?? "-"
    }
}
