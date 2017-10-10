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
final class NewVisitView: UserInterface, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var visitSummaries: [VisitSummary]!
    
    private var TABLEVIEW_CELL_ID = "cell"
    
    //MARK: UITableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitSummaries.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        
        if indexPath.row < visitSummaries.count {
            let visitSummary = visitSummaries[indexPath.row]
            cell.textLabel?.text = visitSummary.traplinesDescription
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Other..."
            cell.accessoryType = .disclosureIndicator
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RECENT"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Select to visit a recent set of traplines or choose another combination."
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < visitSummaries.count {
            let visitSummary = visitSummaries[indexPath.row]
            presenter.didSelectRecentTraplines(traplines: visitSummary.traplines)
        } else {
            presenter.didSelectOther()
        }
    }
    
    //MARK: - Events
    
    func closeButtonAction(sender: UIBarButtonItem) {
        presenter.didSelectCloseButton()
    }
    
    // MARK: Create View
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        return tableView
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonAction(sender:)))
        
        return view
    }()
    
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(tableView)
        self.navigationItem.leftBarButtonItem = closeButton
        
        setConstraints()
    }
    
    func setConstraints() {
        
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }
    
}


//MARK: - NewVisitView API
extension NewVisitView: NewVisitViewApi {
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func displayRecentVisits(visitSummaries: [VisitSummary]?) {
        self.visitSummaries = visitSummaries
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
