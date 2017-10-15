//
//  SideMenuModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - SideMenuRouter API
protocol SideMenuRouterApi: RouterProtocol {
    func showModule(menuItem: MenuItem)
}

//MARK: - SideMenuView API
protocol SideMenuViewApi: UserInterfaceProtocol {
    func displayMenuItems(menuItems: [MenuItem], separatorsAfter: [Int]?)
    func displayUserDetails()
    func showSideBar()
    func hideSideBar(completion: (() -> Void)?)
    func moveSideBar(positionX: CGFloat)
    
}

//MARK: - SideMenuPresenter API
protocol SideMenuPresenterApi: PresenterProtocol {
    //func didSelectLogout()
    func didSelectMenuItem(menuItemIndex: Int)
    func didSelectClose()
}

//MARK: - SideMenuInteractor API
protocol SideMenuInteractorApi: InteractorProtocol {
}
