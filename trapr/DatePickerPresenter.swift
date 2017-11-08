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
    
    override func viewIsAboutToAppear() {
        
        view.setDate(date: initialDate)

        view.setTitle(title: "")
        
        let showTitle = delegate?.datePicker(view, showTextFor: .title) ?? false
        let showToday = delegate?.datePicker(view, showTextFor: .todayButton) ?? false
        let showNow = delegate?.datePicker(view, showTextFor: .nowButton) ?? false
        
        var elementsToShow = [DatePickerElement]()
        if showToday { elementsToShow.append(.todayButton) }
        if showNow { elementsToShow.append(.nowButton) }
        if showTitle {
            elementsToShow.append(.title)
            view.setTitle(title: delegate?.datePicker(view, textFor: .title) ?? "")
        }
        
        view.showElements(elements: elementsToShow)
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
        delegate?.datePicker(view, didSelectDate: date)
        self.didSelectClose()
    }
    
    func didSelectToday() {
        view.setDate(date: Date())
    }
    
    var dateMode: UIDatePickerMode {
        return delegate?.displayMode(self.view) ?? UIDatePickerMode.dateAndTime
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
