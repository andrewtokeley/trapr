//
//  SideMenuView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: SideMenuView Class
final class SideMenuView: UserInterface {
    
    fileprivate let ANIMATION_DURATION_SECS = 0.3
    fileprivate let MENU_CELL_ID = "cell"
    
    fileprivate var menuItems: [MenuItem]!
    fileprivate var separatorsAfter: [Int]?
    
    fileprivate var sideBarWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.7
    }
    
    fileprivate var headerHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.2
    }
    
    //MARK: - Subviews
    
    lazy var backgroundMask: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonClick(sender:))))
        return view
    }()
    
    lazy var sideBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame.origin.x = -self.sideBarWidth
        
        view.addSubview(self.headerBackground)
        view.addSubview(self.menuTableView)
        
        return view
    }()
    
    lazy var headerBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpNavigationBar
        return view
    }()
    
//    lazy var menu: UIStackView = {
//        let menu = UIStackView()
//        menu.axis = .vertical
//        menu.distribution = .fillProportionally
//        menu.spacing = 4
//        //menu.translatesAutoresizingMaskIntoConstraints = false
//        return menu
//    }()

    lazy var menuTableView: UITableView = {
        let menu = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        menu.register(UITableViewCell.self, forCellReuseIdentifier: self.MENU_CELL_ID)
        menu.separatorStyle = .none
        menu.isScrollEnabled = false
        
        menu.delegate = self
        menu.dataSource = self
        return menu
    }()
    
    //MARK: - Events
    
    func closeButtonClick(sender: UIView) {
        presenter.didSelectClose()
    }
    
    func swipe(sender: UIPanGestureRecognizer) {
        presenter.didSelectClose()
    }
    
    //MARK: - UIViewController
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(backgroundMask)
        self.view.addSubview(sideBar)
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(closeButtonClick(sender:)))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        setConstraints()
        
    }
    
    func setConstraints() {
        
        self.backgroundMask.autoPinEdgesToSuperviewEdges()
        
        self.sideBar.autoSetDimension(.width, toSize: self.sideBarWidth)
        self.sideBar.autoPinEdge(toSuperviewEdge: .top, withInset: -10)
        self.sideBar.autoPinEdge(toSuperviewMargin: .bottom)
        
        self.headerBackground.autoPinEdge(.top, to: .top, of: self.sideBar)
        self.headerBackground.autoPinEdge(.left, to: .left, of: self.sideBar)
        self.headerBackground.autoPinEdge(.right, to: .right, of: self.sideBar)
        self.headerBackground.autoSetDimension(.height, toSize: self.headerHeight)
        
        self.menuTableView.autoPinEdge(.top, to: .bottom, of: self.headerBackground, withOffset: 40)
        self.menuTableView.autoPinEdge(.left, to: .left, of: self.sideBar)
        self.menuTableView.autoPinEdge(.right, to: .right, of: self.sideBar)
        self.menuTableView.autoPinEdge(.bottom, to: .bottom, of: self.sideBar)
    }
}

//MARK: - MenuTableView Delegates
extension SideMenuView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MENU_CELL_ID, for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].name
        cell.imageView?.image = menuItems[indexPath.row].image
        
        // add custom separator
        if (self.separatorsAfter?.contains(indexPath.row) ?? false) {
            let separator = UIImageView(frame: CGRect(x: 10, y: cell.bounds.height, width: tableView.bounds.width - 20, height: 1))
            separator.backgroundColor = UIColor.trpBackground
            cell.contentView.addSubview(separator)
        }
        
        return cell
    }
}

//MARK: - SideMenuView API
extension SideMenuView: SideMenuViewApi {
    
    func displayMenuItems(menuItems: [MenuItem], separatorsAfter: [Int]?) {

        self.menuItems = menuItems
        self.separatorsAfter = separatorsAfter
        
        self.menuTableView.reloadData()
        
//        // remove existing items
//        for view in menu.arrangedSubviews {
//            view.removeFromSuperview()
//        }
//
//        // add menu items
//        for item in menuItems {
//            if !(item.isDivider) {
//                let menuItem = MenuItemView(item: item)
//                menuItem.isSelected = item.rawValue == selectedIndex
//                menu.addArrangedSubview(menuItem)
////                let view = UIView()
////                view.backgroundColor = UIColor.red
////                menu.addArrangedSubview(view)
//            } else {
//                let divider = MenuDivider()
//
//                menu.addArrangedSubview(divider)
//            }
//        }
    }
    
    func displayUserDetails() {
        
    }
    
    func showSideBar() {
        
        UIView.animate(withDuration: ANIMATION_DURATION_SECS, animations: {
            self.backgroundMask.alpha = 0.5
            self.sideBar.frame.origin.x = 0
        })
    }
    
    func hideSideBar(completion: (() -> Void)?) {
        UIView.animate(withDuration: ANIMATION_DURATION_SECS, animations: {
            self.backgroundMask.alpha = 0
            self.sideBar.frame.origin.x = -self.sideBarWidth
        }, completion: {
            (flag) in completion?()
        })
    }
    
    func moveSideBar(positionX: CGFloat) {
        self.sideBar.frame.origin.x = positionX
    }
}

// MARK: - SideMenuView Viper Components API

private extension SideMenuView {
    var presenter: SideMenuPresenterApi {
        return _presenter as! SideMenuPresenterApi
    }
    var displayData: SideMenuDisplayData {
        return _displayData as! SideMenuDisplayData
    }
}
