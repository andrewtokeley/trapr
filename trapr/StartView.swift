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
    
    let TABLEVIEW_SCROLL_TITLE_TRIGGER: CGFloat = -80
    let TABLEVIEW_SCROLL_BULGE_LIMIT: CGFloat = -50
    let TABLEVIEW_SECTION_HEADING_SIZE_MAX_SIZE_INCREASE: CGFloat = 5
    
    fileprivate var routeViewModels: [RouteViewModel]?
    fileprivate var visitSummaries: [VisitSummary]?
    fileprivate var routeMenuOptions: [String]?
    
    //MARK: - SubViews
    
    lazy var routeSectionTitleView: UIView = {
        let view = UIView()
        view.addSubview(routeSectionTitleLabel)
        
        routeSectionTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        
        return view
    }()
    
    lazy var routeSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Routes"
        label.font = UIFont.trpLabelBoldLarge
        return label
    }()
    
    lazy var loaderViewController: UIViewController = {
        return LoaderView()
    }()
    
    lazy var addRouteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addRouteButtonClick(sender:)))
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
        newRouteButton.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        view.addSubview(noRouteLabel)
        view.addSubview(newRouteButton)
        
        newRouteButton.autoPinEdge(.top, to: .bottom, of: noRouteLabel, withOffset: LayoutDimensions.spacingMargin)
        newRouteButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
        // hide initially
        view.alpha = 0
        
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
        tableView.backgroundColor = UIColor.trpBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        (tableView as UIScrollView).delegate = self
        
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
    
    @objc func addRouteButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectNewRoute()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = self.addRouteButton
        self.navigationItem.leftBarButtonItem = self.menuButtonItem
      
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubview(routesTableView)
        self.view.addSubview(noRoutesView)
        
        self.setConstraints()
    }
    
    func setConstraints() {

        self.routesTableView.autoPinEdgesToSuperviewEdges()
        
        self.noRoutesView.autoPinEdgesToSuperviewEdges()
        
        self.noRouteLabel.autoPin(toTopLayoutGuideOf: self, withInset: 150)
        self.noRouteLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        self.noRouteLabel.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        
    }
}

extension StartView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let offset = scrollView.contentOffset.y
        //print(offset)
       
        
//        if offset < 0 && offset >= TABLEVIEW_SCROLL_BULGE_LIMIT {
//            // percentage traveled between rest state and the maximum effective drag
//            let delta = abs(offset / TABLEVIEW_SCROLL_BULGE_LIMIT)
//            print("delta: \(delta)")
//
//            // scale factor to apply to size - a percentage of the maximum size increase
//            let maxScale = (30 + TABLEVIEW_SECTION_HEADING_SIZE_MAX_SIZE_INCREASE) / 30
//            print("maxScale: \(maxScale)")
//
//            let scale = (maxScale - 1) * delta + 1
//            print("scale: \(scale)")
//
//            routeSectionTitleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
//        }
    }
}
//MARK: - UITableView
extension StartView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return self.visitSummaries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return routeSectionTitleView
//        }
        return nil
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
            
            let lastVisitedText = NSMutableAttributedString(string: vm.lastVisitedText)
            lastVisitedText.addAttributes([.foregroundColor: UIColor.trpButtonEnabled], range: NSMakeRange(0, lastVisitedText.length - 1))
            
            // add notSent in red if not sync'd
//            if !vm.visitSync {
//                let notSent = NSMutableAttributedString(string: " (not sent)", attributes: [.foregroundColor: UIColor.red])
//                lastVisitedText.append(notSent)
//            }
            
            cell.lastVisitedButton.setAttributedTitle(lastVisitedText, for: .normal)
            
        }
        
       return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 347
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let changeImage = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Change Picture...", handler: {
            (row, index) in
            
            
        })
        changeImage.backgroundColor = UIColor.trpHighlightColor
        return [changeImage]
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
        routesTableView.reloadData()
    }

    func displayRecentVisits(visits: [VisitSummary]?) {
        visitSummaries = visits
    }
    
    func askForNewVisitDate(completion: (Date) -> Void) {
        
    }
    
    func setTitle(title: String, routesSectionTitle: String, routeSectionActionText: String, recentVisitsSectionTitle: String, recentVisitsSectionActionText: String) {
        self.title = title
    }
    
    func showNoRoutesLayout(show: Bool, message: String? = nil ) {
        noRoutesView.alpha = show ? 1 : 0
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
