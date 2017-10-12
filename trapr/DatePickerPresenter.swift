//
//  DatePickerPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - DatePickerPresenter Class
final class DatePickerPresenter: Presenter {
    
    fileprivate var delegate: DatePickerDelegate?
    fileprivate var initialDate: Date!
    
    override func viewHasLoaded() {
        view.setTitle(title: "Visit Date")
        view.setDate(date: initialDate)
    }
    override func viewHasAppeared() {
        view.animateToAppear()
    }
    
    override func setupView(data: Any) {
        if let data = data as? DatePickerSetupData {
            self.delegate = data.delegate
            self.initialDate = data.initialDate
        }
    }
}

// MARK: - DatePickerPresenter API
extension DatePickerPresenter: DatePickerPresenterApi {
    
    func didSelectClose() {
        view.animateToDisappear()
        router.closeModule()
    }
    
    func didSelectDate(date: Date) {
        delegate?.datePicker(datePicker: view, didSelectDate: date)
        self.didSelectClose()
    }
    
    var dateMode: UIDatePickerMode {
        return delegate?.displayMode(datePicker: self.view) ?? UIDatePickerMode.dateAndTime
    }
}

// MARK: - DatePicker Viper Components
private extension DatePickerPresenter {
    var view: DatePickerViewApi {
        return _view as! DatePickerViewApi
    }
    var interactor: DatePickerInteractorApi {
        return _interactor as! DatePickerInteractorApi
    }
    var router: DatePickerRouterApi {
        return _router as! DatePickerRouterApi
    }
}
