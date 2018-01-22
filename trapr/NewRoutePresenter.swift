//
//  NewRoutePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewRoutePresenter Class
final class NewRoutePresenter: Presenter {
    
    fileprivate var newRouteName: String?
    
}

// MARK: - NewRoutePresenter API
extension NewRoutePresenter: NewRoutePresenterApi {
    
    func didSelectNext() {
        
        if let name = newRouteName {
            router.showRouteDashboard(newRouteName: name)
        }
    }
    
    func didSelectCancel() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didUpdateRouteName(name: String?) {
        newRouteName = name
    }
    
}

// MARK: - NewRoute Viper Components
private extension NewRoutePresenter {
    var view: NewRouteViewApi {
        return _view as! NewRouteViewApi
    }
    var interactor: NewRouteInteractorApi {
        return _interactor as! NewRouteInteractorApi
    }
    var router: NewRouteRouterApi {
        return _router as! NewRouteRouterApi
    }
}
