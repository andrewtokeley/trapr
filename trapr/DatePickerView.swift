//
//  DatePickerView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: DatePickerView Class
final class DatePickerView: UserInterface {
    
    //MARK: Subviews
    
    lazy var backgroundMask: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelButtonClick(sender:))))
        return view
    }()
    
    lazy var datePickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.addSubview(self.titleBar)
        view.addSubview(self.datePicker)
        
        return view
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = self.presenter.dateMode
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpBackground
        
        view.addSubview(self.heading)
        view.addSubview(self.doneButton)
        view.addSubview(self.todayButton)
        
        return view
    }()
    
    lazy var heading: UILabel = {
        let label = UILabel()
        label.font = UIFont.trpLabel
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        button.setTitleColor(UIColor.trpButtonDisabled, for: .disabled)
        
        button.addTarget(self, action: #selector(doneButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Today", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        button.setTitleColor(UIColor.trpButtonDisabled, for: .disabled)
        
        button.addTarget(self, action: #selector(todayButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    //MARK: Events
    
    func cancelButtonClick(sender: UIView) {
        presenter.didSelectClose()
    }
    
    func doneButtonClick(sender: UIButton) {
        presenter.didSelectDate(date: self.datePicker.date)
    }
    
    func todayButtonClick(sender: UIButton) {
        presenter.didSelectToday()
    }
        
    //MARK: UIViewController
    override func loadView() {
        super.loadView()
        
        //self.navigationController?.isToolbarHidden = true
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(backgroundMask)
        self.view.addSubview(datePickerContainer)

        let down = UISwipeGestureRecognizer(target: self, action: #selector(cancelButtonClick(sender:)))
        down.direction = .down
        self.view.addGestureRecognizer(down)

        
        setConstraints()
        
    }
    
    func setConstraints() {

        // todo - get the top offset from parent viewcontroller
        backgroundMask.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        
        datePickerContainer.autoPinEdge(toSuperviewEdge: .left)
        datePickerContainer.autoPinEdge(toSuperviewEdge: .right)
        datePickerContainer.autoPinEdge(.top, to: .bottom, of: self.backgroundMask)
        datePickerContainer.autoSetDimension(.height, toSize: 280)
        
        datePicker.autoPinEdge(.left, to: .left, of: datePickerContainer)
        datePicker.autoPinEdge(.right, to: .right, of: datePickerContainer)
        datePicker.autoPinEdge(.bottom, to: .bottom, of: datePickerContainer)
        
        titleBar.autoPinEdge(.left, to: .left, of: datePickerContainer)
        titleBar.autoPinEdge(.right, to: .right, of: datePickerContainer)
        titleBar.autoPinEdge(.top, to: .top, of: datePickerContainer)
        titleBar.autoSetDimension(.height, toSize: 70)

        heading.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
        doneButton.autoPinEdges(toSuperviewMarginsExcludingEdge: .left)
        todayButton.autoPinEdges(toSuperviewMarginsExcludingEdge: .right)
    }
}

//MARK: - DatePickerView API
extension DatePickerView: DatePickerViewApi {
    
    func showToday(show: Bool) {
        todayButton.alpha = show ? 1 : 0
    }
    
    func setDate(date: Date) {
        self.datePicker.date = date
    }
    
    func setTitle(title: String) {
        self.heading.text = title
    }
    
    func animateToAppear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundMask.alpha = 0.3
            
            self.datePickerContainer.frame.origin.y = UIScreen.main.bounds.height - self.datePickerContainer.frame.height
        })
    }
    
    func animateToDisappear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundMask.alpha = 0
            
            self.datePickerContainer.frame.origin.y = UIScreen.main.bounds.height
        })
    }
    
}

// MARK: - DatePickerView Viper Components API
private extension DatePickerView {
    var presenter: DatePickerPresenterApi {
        return _presenter as! DatePickerPresenterApi
    }
}
