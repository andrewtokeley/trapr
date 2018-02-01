//
//  ListPickerModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - ListPickerRouter API
protocol ListPickerRouterApi: RouterProtocol {
    func showChildListPicker(setupData: ListPickerSetupData)
}

//MARK: - ListPickerView API
protocol ListPickerViewApi: UserInterfaceProtocol {
    
    // Can't set tag through property since the View is readonly
    var tag: Int { get }
    func setTag(tag: Int)
    
    func showDoneButton(show: Bool)
    func showCloseButton(show: Bool)
    //func setTitle(title: String)
    func setSelectedIndices(indices: [Int])
    func enableMultiselect(enable: Bool)
    func includeSelectNone(enable: Bool)
}

//MARK: - ListPickerPresenter API
protocol ListPickerPresenterApi: PresenterProtocol {
    func didSelectItem(row: Int)
    func didSelectNoSelection()
    func didSelectAllItems()
    func didSelectNoItems()
    func didSelectDone()
    func didSelectClose()
}

//MARK: - ListPickerInteractor API
protocol ListPickerInteractorApi: InteractorProtocol {
}
