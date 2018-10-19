//
//  SideMenuPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import FirebaseAuth
import GoogleSignIn

// MARK: - SideMenuPresenter Class
final class SideMenuPresenter: Presenter {
    
    fileprivate var delegate: SideMenuDelegate?
    fileprivate var menuItems = [SideBarMenuItem]()
    fileprivate var separatorsAfter: [Int]?
    
    override func viewIsAboutToAppear() {
        view.showSideBar()
    }
    
    override func setupView(data: Any) {
        
        if let setupData = data as? SideMenuSetupData {
            delegate = setupData.delegate
        }
        
        // Get the menu items for this user context
        self.menuItems = [SideBarMenuItem.Map, SideBarMenuItem.Settings, SideBarMenuItem.Divider, SideBarMenuItem.SignOut]
        self.separatorsAfter = nil
        
        if let user = Auth.auth().currentUser {
            view.displayUserDetails(userName: user.displayName ?? "", emailAddress: user.email ?? "")
        }
        view.displayMenuItems(menuItems: self.menuItems, separatorsAfter: self.separatorsAfter)
        
    }
}

// MARK: - SideMenuPresenter API
extension SideMenuPresenter: SideMenuPresenterApi {
    
    func didSelectMenuItem(menuItemIndex: Int) {
        if menuItems[menuItemIndex] == SideBarMenuItem.Settings {
            view.hideSideBar(completion: {
                () in
                self.router.dismiss(completion: {
                    self.delegate?.didSelectMenuItem(menu: .Settings, setupData: nil)
                })
            })
        }
        if menuItems[menuItemIndex] == SideBarMenuItem.Map {
            view.hideSideBar(completion: {
                () in
                self.router.dismiss(completion: {
                    let setupData = MapSetupData()
                    setupData.stations = self.interactor.getStationsForMap()
                    setupData.showHighlightedOnly = false
                    self.delegate?.didSelectMenuItem(menu: .Map, setupData: setupData)
                })
            })
        }
        
        if menuItems[menuItemIndex] == SideBarMenuItem.SignOut {
            view.hideSideBar(completion: {
                () in
                self.router.dismiss(completion: {
                    
                    do {
                        try Auth.auth().signOut()
                        GIDSignIn.sharedInstance()?.signOut()
                        self.delegate?.didSelectMenuItem(menu: .SignOut, setupData: nil)
                    }
                    catch {
                        // if signout fails just ignore
                    }
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
