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
}

//MARK: - ListPickerView API
protocol ListPickerViewApi: UserInterfaceProtocol {
    var tag: Int { get }
    // Can't set tag through property since the View is readonly
    func setTag(tag: Int)
    func setTitle(title: String)
}

//MARK: - ListPickerPresenter API
protocol ListPickerPresenterApi: PresenterProtocol {
    func didSelectItem(row: Int)
}

//MARK: - ListPickerInteractor API
protocol ListPickerInteractorApi: InteractorProtocol {
}
