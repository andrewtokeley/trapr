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
    
    fileprivate var delegate: SideMenuDelegate?
    fileprivate var menuItems = [SideBarMenuItem]()
    fileprivate var separatorsAfter: [Int]?
    
    override func setupView(data: Any) {
        
        if let setupData = data as? SideMenuSetupData {
            delegate = setupData.delegate
        }
        
        // Get the menu items for this user context
        self.menuItems = [SideBarMenuItem.Home, SideBarMenuItem.Map, SideBarMenuItem.Settings, SideBarMenuItem.Sync]
        self.separatorsAfter = [1, 2]
        
        view.displayMenuItems(menuItems: self.menuItems, separatorsAfter: self.separatorsAfter)
        
        view.showSideBar()
    }
}

// MARK: - SideMenuPresenter API
extension SideMenuPresenter: SideMenuPresenterApi {
    
    func didSelectMenuItem(menuItemIndex: Int) {
        if menuItems[menuItemIndex] == SideBarMenuItem.Settings {
            view.hideSideBar(completion: {
                () in
                self.router.dismiss(completion: {
                    self.delegate?.didSelectMenuItem(menu: .Settings)
                })
            })
        }
    }
    
    func didSelectClose() {
        view.hideSideBar(completion: {
            () in
            self.router.dismiss(completion: nil)
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
