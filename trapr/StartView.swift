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
    let SPACING:CGFloat = 20.0
    
    fileprivate var routes: [Route]?
    fileprivate var visitSummaries: [VisitSummary]?
    
    //MARK: - Events
    
    func menuButtonAction(sender: UIBarButtonItem) {
        presenter.didSelectMenu()
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let _ = visitSummaries
//        {
//            return visitSummaries!.count + 1
//        }
//        return 0
        
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
        
//        if (indexPath.row == 0) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NEW_VISIT_CELL_IDENTIFIER, for: indexPath)
//
//            cell.backgroundColor = UIColor.trpVisitTileBackground
//            return cell
//        }
//        else
//        {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VISITS_CELL_IDENTIFIER, for: indexPath) as! VisitCollectionViewCell
//
//            cell.backgroundColor = UIColor.trpVisitTileBackground
//
//            //let dateFormatterPrint = DateFormatter()
//
//            if let visitSummary = visitSummaries?[indexPath.row - 1] {
//                cell.dateDescription?.text = visitSummary.dateOfVisit.string(from: Styles.DATE_FORMAT_LONG)
//                cell.dayDescription?.text = visitSummary.dateOfVisit.string(from: Styles.DATE_FORMAT_DAY)
//                cell.traplinesDescription?.text = visitSummary.route.shortDescription
//            }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ROUTE_CELL_IDENTIFIER, for: indexPath) as! RouteCollectionViewCell
        
        cell.backgroundColor = UIColor.trpVisitTileBackground
        
        //let dateFormatterPrint = DateFormatter()
        
        if let route = routes?[indexPath.row] {
            cell.routeNameLabel?.text = route.name
            cell.routeTrapLinesLabel?.text = route.shortDescription
            cell.daysSinceLastVisitLabel?.text = "20 days"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if (indexPath.row == 0)
//        {
//            // new visit
//            // presenter.didSelectNewVisit()
//        }
//        else
//        {
//            // edit visit
//            if let _ = visitSummaries {
//                presenter.didSelectVisitSummary(visitSummary: visitSummaries![indexPath.row - 1])
//            }
//        }

        if let _ = routes {
            presenter.didSelectRoute(route: routes![indexPath.row])
        }
    }
    
    //MARK: - SubViews
    
    lazy var routesLabel: UILabel = {
        var label = UILabel()
        label.text = "ROUTES"
        label.font = UIFont.trpTableViewSectionHeading
        label.textColor = UIColor.trpTextDark
        return label
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
        layout.sectionInset = UIEdgeInsetsMake(0, self.SPACING, 0, self.SPACING)
        layout.footerReferenceSize = CGSize.zero
        layout.headerReferenceSize = CGSize.zero
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        view.register(UINib(nibName:"RouteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.ROUTE_CELL_IDENTIFIER)
//        view.register(UINib(nibName:"VisitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.VISITS_CELL_IDENTIFIER)
//
//        view.register(UINib(nibName:"NewVisitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.NEW_VISIT_CELL_IDENTIFIER)
        
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
        self.view.addSubview(routesLabel)
        
        self.setConstraints()
    }
    
    func setConstraints() {
        
        self.routesLabel.autoPin(toTopLayoutGuideOf: self, withInset: SPACING)
        self.routesLabel.autoPinEdge(toSuperviewEdge: .left, withInset: SPACING)
        self.routesLabel.autoPinEdge(toSuperviewEdge: .right)
        self.routesLabel.autoSetDimension(.height, toSize: 40)
//        
//        visitsLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(90, 20, 0, 0), excludingEdge: .bottom)
//        visitsLabel.autoSetDimension(.height, toSize: 15)
//        
        routesCollectionView.autoPinEdge(.top, to: .bottom, of: routesLabel, withOffset: 0)
        routesCollectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        routesCollectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        routesCollectionView.autoSetDimension(.height, toSize: 120)
        
    }
}

//MARK: - StartView API
extension StartView: StartViewApi {
    
    func displayRoutes(routes: [Route]?) {
        self.routes = routes
    }
    
    func displayRecentVisits(visits: [VisitSummary]?) {
        visitSummaries = visits
        //visitsCollectionView.reloadData()
    }
    
    func askForNewVisitDate(completion: (Date) -> Void) {
        
    }
    
    func setTitle(title: String) {
        self.title = title
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
