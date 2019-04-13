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
    fileprivate let PROFILE_IMAGE_DIAMETER: CGFloat = 60
    fileprivate let HEADER_HEIGHT: CGFloat = 170
    
    fileprivate var menuItems = [SideBarMenuItem]()
    fileprivate var separatorsAfter: [Int]?
    
    fileprivate var sideBarWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.7
    }
    
//    fileprivate var headerHeight: CGFloat {
//        return UIScreen.main.bounds.height * 0.25
//    }
    
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
        
        // offset so it's not visible
        view.frame.origin.x = -self.sideBarWidth
        
        view.addSubview(self.headerBackground)
        view.addSubview(self.menuTableView)
        
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    lazy var email: UILabel = {
        let email = UILabel()
        email.font = UIFont.trpLabelNormal
        email.textColor = UIColor.white
        //email.font = UIFont.trpLabelSmall
        return email
    }()
    
    lazy var userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont.trpLabelNormal
        userName.textColor = UIColor.white
        userName.font = UIFont.trpLabelNormalBold
        return userName
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "tree"))
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = false
        image.layer.cornerRadius = PROFILE_IMAGE_DIAMETER/2
        image.clipsToBounds = true
        return image
    }()
    
    lazy var headerBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpHighlightColor
        
        view.addSubview(image)
        view.addSubview(userName)
        view.addSubview(email)
        
        email.autoPinEdge(toSuperviewEdge: .bottom, withInset: LayoutDimensions.smallSpacingMargin)
        email.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        
        userName.autoPinEdge(.bottom, to: .top, of: email, withOffset: 0)
        userName.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        
        image.autoPinEdge(toSuperviewEdge: .top, withInset: LayoutDimensions.spacingMargin * 2)
        image.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        image.autoSetDimension(.width, toSize: PROFILE_IMAGE_DIAMETER)
        image.autoSetDimension(.height, toSize: PROFILE_IMAGE_DIAMETER)
        
        return view
    }()
    
    lazy var menuTableView: UITableView = {
        let menu = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        menu.register(UITableViewCell.self, forCellReuseIdentifier: self.MENU_CELL_ID)
        menu.separatorStyle = .none
        menu.isScrollEnabled = false
        
        menu.delegate = self
        menu.dataSource = self
        return menu
    }()
    
    //MARK: - Events
    
    @objc func closeButtonClick(sender: UIView) {
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
        self.sideBar.autoPinEdge(toSuperviewEdge: .bottom)
        
        self.headerBackground.autoPinEdge(.top, to: .top, of: self.sideBar)
        self.headerBackground.autoPinEdge(.left, to: .left, of: self.sideBar)
        self.headerBackground.autoPinEdge(.right, to: .right, of: self.sideBar)
        self.headerBackground.autoSetDimension(.height, toSize: HEADER_HEIGHT)
        
        self.menuTableView.autoPinEdge(.top, to: .bottom, of: self.headerBackground, withOffset: 20)
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
        cell.selectionStyle = .none
        
        // add custom separator
        if (self.separatorsAfter?.contains(indexPath.row) ?? false) {
            let separator = UIImageView(frame: CGRect(x: 10, y: cell.bounds.height, width: tableView.bounds.width - 20, height: 1))
            separator.backgroundColor = UIColor.trpBackground
            cell.contentView.addSubview(separator)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectMenuItem(menuItemIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

//MARK: - SideMenuView API
extension SideMenuView: SideMenuViewApi {
    
    func displayMenuItems(menuItems: [SideBarMenuItem], separatorsAfter: [Int]?) {
        self.menuItems = menuItems
        self.separatorsAfter = separatorsAfter
        self.menuTableView.reloadData()
    }
    
    func displayUserDetails(userName: String, emailAddress: String, imageUrl: URL?) {
        self.userName.text = userName
        self.email.text = emailAddress
        if let url = imageUrl {
            self.image.downloadedFrom(url: url)
        }
    }
    
    func showSideBar() {
        UIView.animate(withDuration: ANIMATION_DURATION_SECS, animations: {
            self.backgroundMask.alpha = 0.3
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
    
//    func moveSideBar(positionX: CGFloat) {
//        self.sideBar.frame.origin.x = positionX
//    }
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
