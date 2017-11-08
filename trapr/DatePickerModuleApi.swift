//
//  DatePickerModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - DatePickerRouter API
protocol DatePickerRouterApi: RouterProtocol {
    func closeModule()
}

//MARK: - DatePickerView API
protocol DatePickerViewApi: UserInterfaceProtocol {
    func animateToAppear()
    func animateToDisappear()
    func setTitle(title: String)
    func setDate(date: Date)
    func showElements(elements: [DatePickerElement])
}

//MARK: - DatePickerPresenter API
protocol DatePickerPresenterApi: PresenterProtocol {
    func didSelectClose()
    func didSelectDate(date: Date)
    func didSelectToday()
    var dateMode: UIDatePickerMode { get }
}

//MARK: - DatePickerInteractor API
protocol DatePickerInteractorApi: InteractorProtocol {
}
