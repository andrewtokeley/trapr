//
//  HeatMapKey.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum HeatMapKeyError: Error {
    case initializationError(String)
}

class HeatMapKey: UIView {
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .trpLabelSmall
        label.textColor = .white
        return label
    }()
    
    private lazy var heatMapStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.axis = .vertical
        return view
    }()
    
    private lazy var heatMapDescriptionsStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.axis = .vertical
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.titleLabel)
        self.addSubview(self.heatMapStackView)
        self.addSubview(self.heatMapDescriptionsStackView)
    }
    
    convenience init(segments: [Segment]) {
        self.init()
        setSegments(segments: segments)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func updateConstraints() {
        
        super.updateConstraints()
        
        titleLabel.autoPinEdge(toSuperviewEdge: .left)
        titleLabel.autoPinEdge(toSuperviewEdge: .right)
        titleLabel.autoPinEdge(toSuperviewEdge: .top)
        
        heatMapStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: LayoutDimensions.smallSpacingMargin)
        heatMapStackView.autoPinEdge(toSuperviewEdge: .left)
        heatMapStackView.autoPinEdge(toSuperviewEdge: .bottom)
        heatMapStackView.autoConstrainAttribute(.width, to: .width, of: self, withMultiplier: 0.25)
        
        heatMapDescriptionsStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: LayoutDimensions.smallSpacingMargin)
        heatMapDescriptionsStackView.autoPinEdge(.left, to: .right, of: heatMapStackView, withOffset: LayoutDimensions.smallSpacingMargin)
        heatMapDescriptionsStackView.autoPinEdge(toSuperviewEdge: .right)
        heatMapDescriptionsStackView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    public func setSegments(segments: [Segment]) {
        
        self.heatMapStackView.removeAllArrangedSubViews()
        self.heatMapDescriptionsStackView.removeAllArrangedSubViews()
        
        for segment in segments {
            let block = UIView()
            block.backgroundColor = segment.colour
            self.heatMapStackView.addArrangedSubview(block)
            
            let description = UILabel()
            description.font = .trpLabelSmall
            description.text = segment.range.description()
            description.textColor = .white
            self.heatMapDescriptionsStackView.addArrangedSubview(description)
        }
    }
}
