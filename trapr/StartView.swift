//
//  StartView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit
import PureLayout

class RouteViewModel {
    var route: Route
    var lastVisitedText: String = ""
    var visitSync: Bool = true
    
    init(route: Route) {
        self.route = route
    }
}

//MARK: StartView Class
final class StartView: UserInterface { //, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let VISITS_CELL_IDENTIFIER = "visitCell"
    let ROUTE_CELL_IDENTIFIER = "routeCell"
    let NEW_VISIT_CELL_IDENTIFIER = "newVisitCell"
    let TABLEVIEW_HEADER_RECENT_VISITS = "headerrecent"
    let TABLEVIEW_CELL_RECENT_VISITS = "cellrecent"
    
    let SECTIONSTRIP_ROUTES = 0
    let SECTIONSTRIP_RECENT_VISITS = 1
    
    fileprivate var routeViewModels: [RouteViewModel]?
    fileprivate var visitSummaries: [VisitSummary]?
    fileprivate var routeMenuOptions: [String]?
    
    //MARK: - SubViews
    lazy var loaderViewController: UIViewController = {
        return LoaderView()
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "show"), style: .plain, target: self, action: #selector(editButtonClick(sender:)))
        return button
    }()
    
//    lazy var noRouteWalker: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "walker")?.changeColor(UIColor.trpNavigationBar))
//        imageView.contentMode = UIViewContentMode.scaleAspectFit
//        return imageView
//    }()
    
    lazy var noRouteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label.font = UIFont.trpTableViewSectionHeading
        label.textAlignment = .center
        return label
    }()
    
    lazy var noRoutesView: UIView = {
        let view = UIView()
        
        let newRouteButton = UIButton()
        newRouteButton.setTitle("Create your first Route", for: .normal)
        newRouteButton.addTarget(self, action: #selector(newRouteButtonClick(sender:)), for: .touchUpInside)
        
        view.addSubview(noRouteLabel)
        view.addSubview(newRouteButton)
        
        noRouteLabel.autoPin(toTopLayoutGuideOf: self, withInset: 150)
        noRouteLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        noRouteLabel.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        
        newRouteButton.autoPinEdge(.top, to: .bottom, of: noRouteLabel, withOffset: LayoutDimensions.spacingMargin)
        newRouteButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
        return view
    }()
    
//    lazy var routesSection: SectionStripView = {
//        let view = Bundle.main.loadNibNamed("SectionStripView", owner: nil, options: nil)?.first as! SectionStripView
//        view.tag = self.SECTIONSTRIP_ROUTES
//        view.backgroundColor = UIColor.trpSectionStrip //UIColor.clear
//        view.delegate = self
//        return view
//    }()
//
//    lazy var recentVisitsSection: SectionStripView = {
//        let view = Bundle.main.loadNibNamed("SectionStripView", owner: nil, options: nil)?.first as! SectionStripView
//        view.tag = self.SECTIONSTRIP_RECENT_VISITS
//        view.backgroundColor = UIColor.trpSectionStrip //UIColor.clear
//        view.delegate = self
//        return view
//    }()
    
//    lazy var visitsLabel: UILabel = {
//        var label = UILabel()
//        label.text = "VISITS"
//        label.font = UIFont.trpTableViewSectionHeading
//        label.textColor = UIColor.trpTextDark
//        return label
//    }()
    
//    lazy var recentVisitsTableView: UITableView = {
//        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
//
//        let nibcell = UINib(nibName: "VisitSummaryTableViewCell", bundle: nil)
//        tableView.register(nibcell, forCellReuseIdentifier: self.TABLEVIEW_CELL_RECENT_VISITS)
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        return tableView
//    }()
    
    lazy var menuButtonItem: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuButtonAction(sender:)))
        
        return view
    }()
    
    lazy var routesTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        let nibcell = UINib(nibName: "RouteTableViewCell", bundle: nil)
        tableView.register(nibcell, forCellReuseIdentifier: self.ROUTE_CELL_IDENTIFIER)
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
//    lazy var routesCollectionView: UICollectionView = {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 160, height: 100)
//        layout.sectionInset = UIEdgeInsetsMake(0, LayoutDimensions.spacingMargin, 0, LayoutDimensions.spacingMargin)
//        layout.footerReferenceSize = CGSize.zero
//        layout.headerReferenceSize = CGSize.zero
//
//        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//
//        view.register(UINib(nibName:"RouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.ROUTE_CELL_IDENTIFIER)
//        view.backgroundColor = UIColor.clear
//        view.delegate = self
//        view.dataSource = self
//
//        return view
//    }()
    
    
    //MARK: - Events
    
    @objc func editButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectEditMenu()
    }
    
    @objc func menuButtonAction(sender: UIBarButtonItem) {
        presenter.didSelectMenu()
    }
    
    @objc func newRouteButtonClick(sender: UIButton) {
        presenter.didSelectNewRoute()
    }
    //MARK: - UICollectionView
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let _ = routes
//        {
//            return routes!.count
//        }
//        return 0
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ROUTE_CELL_IDENTIFIER, for: indexPath) as! RouteCollectionViewCell
//
//        cell.backgroundColor = UIColor.trpVisitTileBackground
//        cell.delegate = self
//
//        //let dateFormatterPrint = DateFormatter()
//
//        if let route = routes?[indexPath.row] {
//            cell.routeNameLabel?.text = route.name
//            cell.routeTrapLinesLabel?.text = route.shortDescription
//
//            if let days = ServiceFactory.sharedInstance.routeService.daysSinceLastVisit(route: route) {
//                if days == 0 {
//                    cell.daysSinceLastVisitLabel?.text = "Today"
//                } else if days == 1 {
//                    cell.daysSinceLastVisitLabel?.text = "Yesterday"
//                } else {
//                    cell.daysSinceLastVisitLabel?.text = "\(days) days"
//                }
//            } else {
//                cell.daysSinceLastVisitLabel?.text = "Not visited"
//            }
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if let _ = routes {
//            presenter.didSelectRoute(route: routes![indexPath.row])
//        }
//    }
    
    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = self.editButton
        self.navigationItem.leftBarButtonItem = self.menuButtonItem
        //self.view.addSubview(routesCollectionView)
        self.view.addSubview(routesTableView)
        
//        self.view.addSubview(routesSection)
//        self.view.addSubview(recentVisitsTableView)
//        self.view.addSubview(recentVisitsSection)
        self.view.addSubview(noRoutesView)
        
        self.setConstraints()
    }
    
    func setConstraints() {
        
//        self.routesSection.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.smallSpacingMargin)
//        self.routesSection.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
//        self.routesSection.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
//        self.routesSection.autoSetDimension(.height, toSize: 40)

//        routesCollectionView.autoPinEdge(.top, to: .bottom, of: routesSection, withOffset: LayoutDimensions.smallSpacingMargin)
//        routesCollectionView.autoPinEdge(toSuperviewEdge: .left, withInset: -LayoutDimensions.smallSpacingMargin)
//        routesCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: -LayoutDimensions.smallSpacingMargin)
//        routesCollectionView.autoSetDimension(.height, toSize: 120)
        
//        self.recentVisitsSection.autoPinEdge(.top, to: .bottom, of: routesCollectionView, withOffset: LayoutDimensions.smallSpacingMargin)
//        self.recentVisitsSection.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
//        self.recentVisitsSection.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
//        self.recentVisitsSection.autoSetDimension(.height, toSize: 40)
//
//        self.recentVisitsTableView.autoPinEdge(.top, to: .bottom, of: self.recentVisitsSection, withOffset: 0)
//        self.recentVisitsTableView.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
//        self.recentVisitsTableView.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
//        self.recentVisitsTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

        self.routesTableView.autoPinEdgesToSuperviewEdges()
        
        self.noRoutesView.autoPinEdgesToSuperviewEdges()
        
    }
}

//MARK: - UITableView
extension StartView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return self.visitSummaries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeViewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.ROUTE_CELL_IDENTIFIER, for: indexPath) as! RouteTableViewCell
        
        if let vm = self.routeViewModels?[indexPath.row] {
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            
            cell.routeNameButton.setTitle(vm.route.name, for: .normal)
            
            if let imageUrl = vm.route.dashboardImage?.imageUrl {
                cell.routeImageView.downloadedFrom(url: imageUrl, contentMode: .scaleAspectFill)
            } else {
                cell.routeImageView.image = indexPath.row % 2 == 0 ? UIImage(named: "RouteImage1") : UIImage(named: "RouteImage2")
            }
            
            // scale image
            //cell.routeImageView.image = cell.routeImageView.image?.scaled(to: CGSize(width: self.view.bounds.width, height: 200), scalingMode: .aspectFit)
            
            let lastVisitedText = NSMutableAttributedString(string: vm.lastVisitedText)
            lastVisitedText.addAttributes([.foregroundColor: UIColor.trpButtonEnabled], range: NSMakeRange(0, lastVisitedText.length - 1))
            
            // add notSent in red if not sync'd
            if !vm.visitSync {
                let notSent = NSMutableAttributedString(string: " (not sent)", attributes: [.foregroundColor: UIColor.red])
                lastVisitedText.append(notSent)
            }
            
            cell.lastVisitedButton.setAttributedTitle(lastVisitedText, for: .normal)
            
        }
        
       return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vm = self.routeViewModels?[indexPath.row] {
//            presenter.didSelectRoute(route: vm.route)
//        }
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 347
    }
}

// MARK: - RouteTableViewCellDelegate
extension StartView: RouteTableViewCellDelegate {
    
    private func getRouteFromCell(cell: RouteTableViewCell) -> Route? {
        if let indexPath = self.routesTableView.indexPath(for: cell) {
            if let vm = self.routeViewModels?[indexPath.row] {
                return vm.route
            }
        }
        return nil
    }
    
    func didClickVisit(_ sender: RouteTableViewCell) {
        if let route = getRouteFromCell(cell: sender) {
            presenter.didSelectNewVisit(route: route)
        }
    }
    
    func didClickRouteName(_ sender: RouteTableViewCell) {
        if let route = getRouteFromCell(cell: sender) {
            presenter.didSelectRoute(route: route)
        }
    }
    
    func didClickLastVisited(_ sender: RouteTableViewCell) {
        
        if let route = getRouteFromCell(cell: sender) {
            presenter.didSelectLastVisited(route: route)
        }
    }
    
    func didClickRouteImage(_ sender: RouteTableViewCell) {
        
        if let route = getRouteFromCell(cell: sender) {
            presenter.didSelectRouteImage(route: route)
        }
    }
}

//MARK: - SectionStripDelegate
extension StartView: SectionStripViewDelegate {
    
    func sectionStrip(_ sectionStripView: SectionStripView, didSelectActionButton: UIButton) {
        if sectionStripView.tag == SECTIONSTRIP_ROUTES {
            presenter.didSelectNewRoute()
        } else if sectionStripView.tag == SECTIONSTRIP_RECENT_VISITS {
            print("show all")
        }
    }
}

//MARK: - RouteCollectionViewCellDelegate
//extension StartView: RouteCollectionViewCellDelegate {
//
//    func routeCollectionViewCellVisitClicked(_ routeCollectionViewCell: RouteCollectionViewCell) {
//        if let index = routesCollectionView.indexPath(for: routeCollectionViewCell)?.row {
//            if let route = self.routes?[index] {
//                presenter.didSelectNewVisit(route: route)
//            }
//        }
//    }
//
//    func routeCollectionViewCellMenuClicked(_ routeCollectionViewCell: RouteCollectionViewCell) {
//
//        // make sure the presenter knows we're about to render the menu for the route
//        if let index = routesCollectionView.indexPath(for: routeCollectionViewCell)?.row {
//            presenter.didSelectRouteMenu(routeIndex: index)
//        }
//    }
//
//    func routeCollectionViewCell(numberOfActionsFor routeCollectionViewCell: RouteCollectionViewCell) -> Int {
//
//        // make sure the presenter knows we're about to render the menu for the route
//        if let index = routesCollectionView.indexPath(for: routeCollectionViewCell)?.row {
//            presenter.didSelectRouteMenu(routeIndex: index)
//
//            return self.routeMenuOptions!.count
//        }
//        return 0
//    }
//
////    func routeCollectionViewCell(_ routeCollectionViewCell: RouteCollectionViewCell, didSelectActionWith title: String) {
////        if let _ = self.routeMenuOptions {
////            if let index = routesCollectionView.indexPath(for: routeCollectionViewCell)?.row {
////                presenter.didSelectRouteMenuItem(routeIndex: index, menuItemIndex: self.routeMenuOptions!.index(of: title)!)
////            }
////        }
////    }
//
//    func routeCollectionViewCell(_ routeCollectionViewCell: RouteCollectionViewCell, actionTextAt index: Int) -> String? {
//        return self.routeMenuOptions?[index]
//    }
//
//    func routeCollectionViewCell(hostingViewControllerFor routeCollectionViewCell: RouteCollectionViewCell) -> UIViewController {
//        return self
//    }
//
//}

//MARK: - StartViewAPI
extension StartView: StartViewApi {
    
    func showLoadingScreen() {
        
        embed(childViewController: loaderViewController)
    }
    
    func hideLoadingScreen() {
        if loaderViewController.parent == self {
            unembed(childViewController: loaderViewController)
            present(loaderViewController, animated: false, completion: nil)
        }
    }
    
    func setRouteMenu(options: [String]) {
        self.routeMenuOptions = options
    }
    
    func displayRoutes(routeViewModels: [RouteViewModel]?) {
        self.routeViewModels = routeViewModels
        //routesCollectionView.reloadData()
        routesTableView.reloadData()
    }

//    func updateImageForRoute(route: Route, imageUrl: URL) {
//        
//        
//    }
    
    func displayRecentVisits(visits: [VisitSummary]?) {
        visitSummaries = visits
        //recentVisitsTableView.reloadData()
    }
    
    func askForNewVisitDate(completion: (Date) -> Void) {
        
    }
    
    func setTitle(title: String, routesSectionTitle: String, routeSectionActionText: String, recentVisitsSectionTitle: String, recentVisitsSectionActionText: String) {
        self.title = title
//        self.routesSection.titleLabel.text = routesSectionTitle
//        self.routesSection.actionButton.setTitle(routeSectionActionText, for: .normal)
//
//        self.recentVisitsSection.titleLabel.text = recentVisitsSectionTitle
//        self.recentVisitsSection.actionButton.setTitle(recentVisitsSectionActionText, for: .normal)
    }
    
    func showNoRoutesLayout(show: Bool, message: String? = nil ) {
        noRoutesView.alpha = show ? 1 : 0
//        recentVisitsSection.alpha = show ? 0 : 1
//        routesSection.alpha = show ? 0 : 1
        noRouteLabel.text = message
    }
}

// MARK: - StartView Viper Components API
private extension StartView {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
    var displayData: StartDisplayData {
        return _displayData as! StartDisplayData
    }
}
