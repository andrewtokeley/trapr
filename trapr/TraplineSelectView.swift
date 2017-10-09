//
//  TraplineSelectView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: TraplineSelectView Class
final class TraplineSelectView: UserInterface, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var traplines: [Trapline]!
    
    private var TABLEVIEW_CELL_ID = "cell"
    
    //MARK: UITableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        let trapline = traplines[indexPath.row]
        cell.textLabel?.text = trapline.code
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            presenter.didDeselectTrapline(trapline: self.traplines[indexPath.row])
        } else {
            cell?.accessoryType = .checkmark
            presenter.didSelectTrapline(trapline: self.traplines[indexPath.row])
        }
    }
    
    // MARK: Create View
    
    lazy var selectedTraplinesText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(selectedTraplinesText)
        self.view.addSubview(tableView)
        
        setConstraints()
        
    }
        
    func setConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }

}

//MARK: - TraplineSelectView API
extension TraplineSelectView: TraplineSelectViewApi {
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setSelectedTraplinesDescription(description: String) {
        self.selectedTraplinesText.text = description
    }
    
    func updateDisplay(traplines: [Trapline]) {
        self.traplines = traplines
        self.tableView.reloadData()
    }

}

// MARK: - TraplineSelectView Viper Components API
private extension TraplineSelectView {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
    var displayData: TraplineSelectDisplayData {
        return _displayData as! TraplineSelectDisplayData
    }
}
