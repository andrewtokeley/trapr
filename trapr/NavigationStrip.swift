//
//  NavigationStrip.swift
//  trapr
//
//  Created by Andrew Tokeley on 8/09/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

struct NavigationStripItem {
    var title: String
    var itemData: Any?
}

class NavigationStrip: UIView {
    
    
    private var currentIndex: Int = 0
    private var currentItem: NavigationStripItem {
        return items[self.currentIndex]
    }
    
    private let BUTTON_BACK: Int = 0
    private let BUTTON_FORWARD: Int = 1
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak private var forwardButton: UIButton!
    @IBOutlet weak private var backButton: UIButton!

    public var items = [NavigationStripItem]()
    public var delegate: NavigationStripDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(items: [NavigationStripItem]) {
        self.init(frame: CGRect.zero)
        self.setItems(items)
    }
    
    private func setupView() {
        
        Bundle.main.loadNibNamed("NavigationStrip", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textLabel.font = UIFont.trpLabelNormal
        
        backButton.setImage(backButton.currentImage?.changeColor(.trpHighlightColor), for: .normal)
        backButton.tag = BUTTON_BACK
        backButton.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        
        forwardButton.setImage(forwardButton.currentImage?.changeColor(.trpHighlightColor), for: .normal)
        forwardButton.tag = BUTTON_FORWARD
        forwardButton.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func buttonClick(sender: UIButton) {
        if sender.tag == BUTTON_BACK {
            if self.currentIndex > 0 {
                self.currentIndex -= 1
            }
        } else if sender.tag == BUTTON_FORWARD {
            if self.currentIndex < items.count - 1 {
                self.currentIndex += 1
            }
        }
        updateDisplay()
        
        delegate?.navigationStrip(self, navigatedToItemAt: self.currentIndex)
    }
    
    public func setItems(_ items: [NavigationStripItem], selectedItemIndex: Int = 0) {
        self.items.removeAll()
        self.items.append(contentsOf: items)
        
        self.currentIndex = selectedItemIndex
        
        updateDisplay()
    }
    
    private func updateDisplay() {
        backButton.isEnabled = self.currentIndex > 0
        forwardButton.isEnabled = self.currentIndex < items.count - 1

        textLabel.text = currentItem.title
    }
}
