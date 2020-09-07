//
//  BarChartLegendItem.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

struct BarChartLegendItemData {
    /// Display text located above the value
    var text: String?
    
    /// Value to be displayed
    var value: Int
    
    /// Colour to be applied to the text
    var textColour: UIColor
    
    /**
     Delta change of the current value compared to a previous period
     */
    var deltaValue: Int?
    
    /// Optional set of characters that will be added to the delta value. For example "%" or "$"
    var deltaValueSuffix: String?
    
}

class BarChartLegendItem: UIView {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.trpLabelBoldSmall
        label.textColor = UIColor.trpTextDark
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.trpLabelNormal
        label.textColor = UIColor.trpTextDark
        label.textAlignment = .center
        return label
    }()
    
    private lazy var deltaValueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(textLabel)
        self.addSubview(valueLabel)
        self.addSubview(deltaValueLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        textLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        textLabel.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        textLabel.autoPinEdge(toSuperviewEdge: .top)
        
        valueLabel.autoCenterInSuperview()
        
        deltaValueLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        //deltaValueLabel.autoSetDimension(.width, toSize: 40)
        deltaValueLabel.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    // MARK: - Render
    
    public func updateDisplay(data: BarChartLegendItemData) {
        textLabel.text = data.text
        textLabel.textColor = data.textColour
        valueLabel.text = String(data.value)
        
        if let deltaValue = data.deltaValue {
            deltaValueLabel.attributedText = getAttributedStringForDeltaValueLabel(value: deltaValue, suffix: data.deltaValueSuffix)
        } else {
            deltaValueLabel.text = nil
        }
    }
    
    private func getAttributedStringForDeltaValueLabel(value: Int, suffix: String?) -> NSMutableAttributedString {
        
        let deltaArrow = (value >= 0) ? "↑" : "↓"
        let deltaText = String(value) + (suffix ?? "")
        
        let attrString = NSMutableAttributedString(string: deltaArrow + deltaText, attributes: nil)
        let rangeArrow = (attrString.string as NSString).range(of: deltaArrow)
        let rangeValue = (attrString.string as NSString).range(of: deltaText)

        let arrowColor = (value < 0) ? UIColor.trpRed : .trpHighlightColor
        attrString.addAttributes([
                    .foregroundColor: arrowColor,
                    .font: UIFont.trpLabelSmall],
                    range: rangeArrow)
        attrString.addAttributes([
                    .foregroundColor: UIColor.trpTextDark,
                    .font: UIFont.trpLabelSmall],
                    range: rangeValue)
        return attrString
    }
    
}
