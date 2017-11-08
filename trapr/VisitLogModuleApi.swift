//
//  VisitLogModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - VisitLogRouter API
protocol VisitLogRouterApi: RouterProtocol {
    func showDatePicker(setupData: DatePickerSetupData)
    func showListPicker(setupData: ListPickerSetupData)
    //func showLuresListPicker(setupData: ListPickerSetupData)
}

//MARK: - VisitLogView API
protocol VisitLogViewApi: UserInterfaceProtocol {
    func displayVisit(visit: Visit, showCatchSection: Bool)
    func displayDateTime(date: Date)
    func displaySpecies(name: String)
}

//MARK: - VisitLogPresenter API
protocol VisitLogPresenterApi: PresenterProtocol {
    func didSelectToChangeTime()
    func didSelectToChangeSpecies()
    func didSelectToChangeLure()
}

//MARK: - VisitLogInteractor API
protocol VisitLogInteractorApi: InteractorProtocol {
    func retrieveSpeciesList(callback: ([Species]) -> Swift.Void )
    func retrieveLuresList(callback: ([Lure]) -> Swift.Void )
    func saveVisit(visit: Visit)
}
