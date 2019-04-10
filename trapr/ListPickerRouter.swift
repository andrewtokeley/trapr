//
//  ListPickerRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ListPickerRouter class
final class ListPickerRouter: Router {
}

// MARK: - ListPickerRouter API
extension ListPickerRouter: ListPickerRouterApi {

    func showChildListPicker(setupData: ListPickerSetupData) {
        let module = AppModules.listPicker.build()
        module.router.show(from: viewController, embedInNavController: false, setupData: setupData)
    }
}

// MARK: - ListPicker Viper Components
private extension ListPickerRouter {
    var presenter: ListPickerPresenterApi {
        return _presenter as! ListPickerPresenterApi
    }
}
