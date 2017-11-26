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

//MARK: StartView Class
final class StartView: UserInterface, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let VISITS_CELL_IDENTIFIER = "visitCell"
    let ROUTE_CELL_IDENTIFIER = "routeCell"
    let NEW_VISIT_CELL_IDENTIFIER = "newVisitCell"
    
    let SECTIONSTRIP_ROUTES = 0
    let SECTIONSTRIP_RECENT_VISITS = 1
    
    fileprivate var routes: [Route]?
    fileprivate var visitSummaries: [VisitSummary]?
    fileprivate var routeMenuOptions: [String]?
    
    //MARK: - Events
    
    func menuButtonAction(sender: UIBarButtonItem) {
        presenter.didSelectMenu()
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = routes
        {
            return routes!.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ROUTE_CELL_IDENTIFIER, for: indexPath) as! RouteCollectionViewCell
        
        cell.backgroundColor = UIColor.trpVisitTileBackground
        cell.delegate = self
        
        //let dateFormatterPrint = DateFormatter()
        
        if let route = routes?[indexPath.row] {
            cell.routeNameLabel?.text = route.name
            cell.routeTrapLinesLabel?.text = route.shortDescription
            cell.daysSinceLastVisitLabel?.text = "20 days"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let _ = routes {
            presenter.didSelectRoute(route: routes![indexPath.row])
        }
    }
    
    //MARK: - SubViews

    lazy var routesSection: SectionStripView = {
        let view = Bundle.main.loadNibNamed("SectionStripView", owner: nil, options: nil)?.first as! SectionStripView
        view.tag = self.SECTIONSTRIP_ROUTES
        //view.titleLabel.font = UIFont.trpLabelLarge
        view.backgroundColor = UIColor.clear
        view.delegate = self
        return view
    }()
    
    lazy var recentVisitsSection: SectionStripView = {
        let view = Bundle.main.loadNibNamed("SectionStripView", owner: nil, options: nil)?.first as! SectionStripView
        view.tag = self.SECTIONSTRIP_RECENT_VISITS
        //view.titleLabel.font = UIFont.trpLabelLarge
        view.backgroundColor = UIColor.clear
        view.delegate = self
        return view
    }()
    
    lazy var visitsLabel: UILabel = {
        var label = UILabel()
        label.text = "VISITS"
        label.font = UIFont.trpTableViewSectionHeading
        label.textColor = UIColor.trpTextDark
        return label
    }()
    
    lazy var menuButtonItem: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuButtonAction(sender:)))
        
        return view
    }()
    
    lazy var routesCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 120)
        layout.sectionInset = UIEdgeInsetsMake(0, LayoutDimensions.spacingMargin, 0, LayoutDimensions.spacingMargin)
        layout.footerReferenceSize = CGSize.zero
        layout.headerReferenceSize = CGSize.zero
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        view.register(UINib(nibName:"RouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.ROUTE_CELL_IDENTIFIER)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        print("Start viewload")
    }
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.leftBarButtonItem = self.menuButtonItem
        self.view.addSubview(routesCollectionView)
        self.view.addSubview(routesSection)
        self.view.addSubview(recentVisitsSection)
        
        self.setConstraints()
    }
    
    func setConstraints() {
        
        self.routesSection.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        self.routesSection.autoPinEdge(toSuperviewEdge: .left)
        self.routesSection.autoPinEdge(toSuperviewEdge: .right)
        self.routesSection.autoSetDimension(.height, toSize: 40)

        routesCollectionView.autoPinEdge(.top, to: .bottom, of: routesSection, withOffset: LayoutDimensions.spacingMargin)
        routesCollectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        routesCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        routesCollectionView.autoSetDimension(.height, toSize: 120)
        
        self.recentVisitsSection.autoPinEdge(.top, to: .bottom, of: routesCollectionView, withOffset: LayoutDimensions.spacingMargin)
        self.recentVisitsSection.autoPinEdge(toSuperviewEdge: .left)
        self.recentVisitsSection.autoPinEdge(toSuperviewEdge: .right)
        self.recentVisitsSection.autoSetDimension(.height, toSize: 40)
        
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
extension StartView: RouteCollectionViewCellDelegate {
    func routeCollectionViewCell(numberOfActionsFor routeCollectionViewCell: RouteCollectionViewCell) -> Int {
        
        // make sure the presenter knows we're about to render the menu for the route
        if let index = routesCollectionView.indexPath(for: routeCollectionViewCell)?.row {
            presenter.didSelectRouteMenu(routeIndex: index)
            
            return self.routeMenuOptions!.count
        }
        return 0
    }
    
    func routeCollectionViewCell(_ routeCollectionViewCell: RouteCollectionViewCell, didSelectActionWith title: String) {
        if let _ = self.routeMenuOptions {
            if let index = routesCollectionView.indexPath(for: routeCollectionViewCell)?.row {
                presenter.didSelectRouteMenuItem(routeIndex: index, menuItemIndex: self.routeMenuOptions!.index(of: title)!)
            }
        }
    }
    
    func routeCollectionViewCell(_ routeCollectionViewCell: RouteCollectionViewCell, actionTextAt index: Int) -> String? {
        return self.routeMenuOptions?[index]
    }
    
    func routeCollectionViewCell(hostingViewControllerFor routeCollectionViewCell: RouteCollectionViewCell) -> UIViewController {
        return self
    }
    
}

//MARK: - StartView API
extension StartView: StartViewApi {
    
    func setRouteMenu(options: [String]) {
        self.routeMenuOptions = options
    }
    
    func displayRoutes(routes: [Route]?) {
        self.routes = routes
        routesCollectionView.reloadData()
    }
    
    func displayRecentVisits(visits: [VisitSummary]?) {
        visitSummaries = visits
        //visitsCollectionView.reloadData()
    }
    
    func askForNewVisitDate(completion: (Date) -> Void) {
        
    }
    
    func setTitle(title: String, routesSectionTitle: String, routeSectionActionText: String, recentVisitsSectionTitle: String, recentVisitsSectionActionText: String) {
        self.title = title
        self.routesSection.titleLabel.text = routesSectionTitle
        self.routesSection.actionButton.setTitle(routeSectionActionText, for: .normal)
        
        self.recentVisitsSection.titleLabel.text = recentVisitsSectionTitle
        self.recentVisitsSection.actionButton.setTitle(recentVisitsSectionActionText, for: .normal)
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
