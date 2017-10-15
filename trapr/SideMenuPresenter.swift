//
//  SideMenuPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - SideMenuPresenter Class
final class SideMenuPresenter: Presenter {
    
    fileprivate var menuItems = [MenuItem]()
    fileprivate var separatorsAfter: [Int]?
    
    override func viewIsAboutToAppear() {
        
        // Get the menu items for this user context
        self.menuItems = [MenuItem.Home, MenuItem.Map, MenuItem.Settings, MenuItem.Sync]
        self.separatorsAfter = [1, 2]
        
        view.displayMenuItems(menuItems: self.menuItems, separatorsAfter: self.separatorsAfter)
        
        view.showSideBar()
    }
}

// MARK: - SideMenuPresenter API
extension SideMenuPresenter: SideMenuPresenterApi {
    
    func didSelectMenuItem(menuItemIndex: Int) {
        
    }
    
    func didSelectClose() {
        view.hideSideBar(completion: {
            () in
            self._view.dismiss(animated: false, completion: nil)
        })
    }
}

// MARK: - SideMenu Viper Components
private extension SideMenuPresenter {
    var view: SideMenuViewApi {
        return _view as! SideMenuViewApi
    }
    var interactor: SideMenuInteractorApi {
        return _interactor as! SideMenuInteractorApi
    }
    var router: SideMenuRouterApi {
        return _router as! SideMenuRouterApi
    }
}
