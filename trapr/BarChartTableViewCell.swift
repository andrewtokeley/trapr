//
//  CatchesChartTableViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import iCarousel
import Charts

class BarChartTableViewCell : UITableViewCell {

    private var currentPeriodRawData: BarChartViewEx.BarChartDataRaw?
    private var currentPeriodTitle: String?
    
    private var lastPeriodRawData: BarChartViewEx.BarChartDataRaw?
    private var lastPeriodTitle: String?
    
    //MARK: - Subviews
    
    private lazy var lastPeriodButton: UIButton = {
        let button = UIButton(type: .custom)
        let lessThanImage = UIImage(named: "lessthan")?.changeColor(.trpHighlightColor)
        button.setImage(lessThanImage, for: .normal)
        button.addTarget(self, action: #selector(lastPeriodButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .trpLabelNormal
        view.textColor = .trpTextDark
        return view
    }()
    
    private lazy var currentPeriodButton: UIButton = {
        let button = UIButton(type: .custom)
        let greaterThanImage = UIImage(named: "greaterthan")?.changeColor(.trpHighlightColor)
        button.setImage(greaterThanImage, for: .normal)
        button.addTarget(self, action: #selector(currentPeriodButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var chart: BarChartViewEx = {
        let chart = BarChartViewEx()
        
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
    
    private var legendStripItemView: BarChartLegendItem {
        let view = BarChartLegendItem(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return view
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up view
    
    private func setupView() {
        self.contentView.addSubview(lastPeriodButton)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(currentPeriodButton)
        self.contentView.addSubview(chart)
        self.contentView.addSubview(legendStrip)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        lastPeriodButton.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        lastPeriodButton.autoPinEdge(toSuperviewEdge: .top, withInset: LayoutDimensions.spacingMargin)
        lastPeriodButton.autoSetDimension(.width, toSize: 25)
        lastPeriodButton.autoSetDimension(.height, toSize: 25)
        
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: LayoutDimensions.spacingMargin)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        currentPeriodButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        currentPeriodButton.autoPinEdge(toSuperviewEdge: .top, withInset: LayoutDimensions.spacingMargin)
        currentPeriodButton.autoSetDimension(.width, toSize: 25)
        currentPeriodButton.autoSetDimension(.height, toSize: 25)
        
        legendStrip.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        legendStrip.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        legendStrip.autoPinEdge(toSuperviewEdge: .bottom, withInset: LayoutDimensions.spacingMargin)
        legendStrip.autoSetDimension(.height, toSize: 60)
        
        chart.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        chart.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        chart.autoPinEdge(.top, to: .bottom, of: lastPeriodButton, withOffset: LayoutDimensions.smallSpacingMargin)
        chart.autoPinEdge(.bottom, to: .top, of: legendStrip, withOffset: -LayoutDimensions.smallSpacingMargin)
        
    }

    // MARK: - Helpers
    
    private func enableNavigation(_ previousChart: Bool, _ nextChart: Bool) {
        lastPeriodButton.isEnabled = previousChart
        currentPeriodButton.isEnabled = nextChart
    }
    
    // MARK: - Events
    
    @objc private func lastPeriodButtonClicked(sender: UIButton) {
        if let lastPeriodRawData = self.lastPeriodRawData {
            self.enableNavigation(false, true)
            self.drawChart(data: lastPeriodRawData, title: self.lastPeriodTitle, lastPeriod: nil)
        }
    }
    
    @objc private func currentPeriodButtonClicked(sender: UIButton) {
        if let currentPeriodRawData = self.currentPeriodRawData {
            enableNavigation(lastPeriodRawData != nil, false)
            self.drawChart(data: currentPeriodRawData, title: self.currentPeriodTitle, lastPeriod: self.lastPeriodRawData)
        }
    }
    
    // MARK: - Render
    
    public func configureChart(currentData: StackCount?, dataTitle: String?, lastPeriodData: StackCount?, lastPeriodTitle: String?) {
        
        self.currentPeriodTitle = dataTitle
        self.lastPeriodTitle = lastPeriodTitle
        
        if let data = currentData {
            if !data.isZero {
                let yValues = data.counts.map({ $0.map( { Double($0) }) })
                self.currentPeriodRawData = BarChartViewEx.BarChartDataRaw(
                    yValues: yValues,
                    stackLabels: data.labels,
                    stackColours: UIColor.trpStackChartColors)
                
                if let lastPeriod = lastPeriodData {
                    if !lastPeriod.isZero {
                        self.lastPeriodRawData = BarChartViewEx.BarChartDataRaw(
                            yValues: lastPeriod.counts.map({ $0.map( { Double($0) }) }),
                            stackLabels: lastPeriod.labels,
                            stackColours: UIColor.trpStackChartColors)
                    }
                }
                
                if let currentMaxY = self.currentPeriodRawData?.yValues.compactMap({ $0.sum()}).max() {
                    let maxY = max(
                        currentMaxY,
                        self.lastPeriodRawData?.yValues.compactMap({ $0.sum()}).max() ?? 0
                        )
                    chart.getAxis(.left).axisMaximum = maxY
                    chart.getAxis(.right).axisMaximum = maxY
                }
                
                self.enableNavigation(self.lastPeriodRawData != nil, false)
                
                drawChart(data: self.currentPeriodRawData!, title: self.currentPeriodTitle, lastPeriod: self.lastPeriodRawData)
            }
        } else {
            // draw empty state
        }
    }
    
    private func drawChart(data: BarChartViewEx.BarChartDataRaw, title: String?, lastPeriod: BarChartViewEx.BarChartDataRaw?) {
        
        self.chart.drawChart(rawData: data)
        self.titleLabel.text = title
        
        legendStrip.removeAllArrangedSubViews()
        
        let legendItems = self.legendData(chartData: data, lastPeriod: lastPeriod)
        for item in legendItems {
            let view = self.legendStripItemView
            view.updateDisplay(data: item)
            legendStrip.addArrangedSubview(view)
        }
    }
    
    /**
     Extracts the legendData from the raw data
    */
    private func legendData(chartData: BarChartViewEx.BarChartDataRaw, lastPeriod:BarChartViewEx.BarChartDataRaw?) -> [BarChartLegendItemData] {
        
        var result = [BarChartLegendItemData]()
        
        for i in 0...chartData.stackLabels.count - 1 {
            let sumForStack = Int(chartData.yValues.reduce(0, { $0 + $1[i] }))
            
            // Work out the sums for the preview period and the equivalent stack
            // Can't assume the stacks are in the same order, must rely on the stacklabels being the
            // same between years.
            var deltaValue: Int?
            var deltaValueSuffix: String? = nil
            if let lastPeriod = lastPeriod {
                // Equivalent stack index
                if let index = lastPeriod.stackLabels.firstIndex(of: chartData.stackLabels[i]) {
                    let sumForStackLastPeriod = Int(lastPeriod.yValues.reduce(0, { $0 + $1[index] }))
                    deltaValue = Int((Double(sumForStack - sumForStackLastPeriod)/Double(sumForStackLastPeriod)) * 100.0)
                    deltaValueSuffix = "%"
                } else {
                    // there is nothing to compare in the previous period
                }
            }
            
            result.append(BarChartLegendItemData(
                text: chartData.stackLabels[i],
                value: sumForStack,
                textColour: chartData.stackColours[i],
                deltaValue: deltaValue,
                deltaValueSuffix: deltaValueSuffix))
        }
        return result
    }
    
}

// MARK: - IAxisValueFormatter
extension BarChartTableViewCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        // This method is only called for the xAxis and requires us to convert the index value into a month character.
        var monthsOffset: Int
        monthsOffset = -(12 - (Int(value) + 1))
        
        let displayMonth = Date().add(0, monthsOffset, 0)
        return displayMonth.toString(format: "MMMMM")
    }
}




