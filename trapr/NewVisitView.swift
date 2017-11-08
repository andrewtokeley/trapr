//
//  NewVisitView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 7/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: NewVisitView Class
final class NewVisitView: UserInterface {
    
    fileprivate var visitSummaries: [VisitSummary]!
    fileprivate var routes: [Route]!
    
    fileprivate let TABLEVIEW_CELL_ID = "cell"
    fileprivate let ROW_ACTION_DELETE = "Delete"
    fileprivate let NEW_ROUTE_LABEL = "New Route..."
    fileprivate let ROUTE_SECTION_HEADING = "Route"
    fileprivate let ROUTE_SECTION_FOOTER_TEXT = "Select a Route to visit, or create a new one."
    fileprivate let CLOSE_BUTTON_IMAGE_NAME = "close"
    
    fileprivate let SECTION_ROUTES = 0
    fileprivate let SECTION_NEW_ROUTE = 1
    
    //MARK: - Events
    
    func closeButtonAction(sender: UIBarButtonItem) {
        presenter.didSelectCloseButton()
    }
    
    // MARK: Create View
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 25
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: self.CLOSE_BUTTON_IMAGE_NAME), style: .plain, target: self, action: #selector(closeButtonAction(sender:)))
        
        return view
    }()
    
    override func loadView() {
        print ("loadview")
        super.loadView()
        
        self.view.addSubview(tableView)
        self.navigationItem.leftBarButtonItem = closeButton
        
        setConstraints()
    }
    
    func setConstraints() {
        
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }
    
}

//MARK: - UITableview
extension NewVisitView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == SECTION_ROUTES ? routes.count : section == SECTION_NEW_ROUTE ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID) ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: TABLEVIEW_CELL_ID)
        
        if indexPath.section == SECTION_ROUTES {
        
            let route = routes[indexPath.row]
            cell.textLabel?.text = route.shortDescription
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .none
            cell.detailTextLabel?.text = route.longDescription
            
        } else {
            
            cell.textLabel?.text = NEW_ROUTE_LABEL
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .disclosureIndicator
            
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == SECTION_ROUTES ? ROUTE_SECTION_HEADING : ""
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == SECTION_NEW_ROUTE ? ROUTE_SECTION_FOOTER_TEXT : ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == SECTION_ROUTES {
            
            let route = routes[indexPath.row]
            presenter.didSelectRecentRoute(route: route)
            
        } else if indexPath.section == SECTION_NEW_ROUTE {
            
            presenter.didSelectOther()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.section == SECTION_ROUTES
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: ROW_ACTION_DELETE) { (action, indexPath) in
            
            if action.title == self.ROW_ACTION_DELETE {
                
                // delete this route
                let route = self.routes[indexPath.row]
                
                self.presenter.didSelectDeleteRoute(route: route)
            }
        }
        
        delete.backgroundColor = UIColor.red
        return [delete]
    }
}
//MARK: - NewVisitView API
extension NewVisitView: NewVisitViewApi {
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func displayRecentRoutes(routes: [Route]?) {
        self.routes = routes
        self.tableView.reloadData()
    }
    
}

// MARK: - NewVisitView Viper Components API
private extension NewVisitView {
    var presenter: NewVisitPresenterApi {
        return _presenter as! NewVisitPresenterApi
    }
    var displayData: NewVisitDisplayData {
        return _displayData as! NewVisitDisplayData
    }
}
