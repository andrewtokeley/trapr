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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TRAPLINES"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        let trapline = traplines[indexPath.row]
        cell.textLabel?.text = trapline.code
        cell.selectionStyle = .none
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
    
    //MARK: Events
    
    func visitButtonClicked(sender: UIButton) {
        presenter.didSelectVisitButton()
    }
    
    // MARK: Create View
    
    lazy var visitButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Visit", for: .normal)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        button.setTitleColor(UIColor.trpButtonDisabled, for: .disabled)
        
        button.addTarget(self, action: #selector(visitButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var selectedTraplinesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.addSubview(self.selectedTraplinesText)
        view.addSubview(self.visitButton)
        return view
    }()
    
//    lazy var selectedTraplinesLabel: UILabel = {
//        let label = UILabel()
//        label.text = "SELECTION"
//        label.backgroundColor = UIColor.clear
//        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
//        label.textAlignment = .left
//        return label
//    }()
    
    lazy var selectedTraplinesText: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.trpLabel
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.trpBackground
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.view.addSubview(selectedTraplinesView)
        self.view.addSubview(tableView)
        
        setConstraints()
        
    }
        
    func setConstraints() {
        //self.selectedTraplinesText.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        
        self.selectedTraplinesView.autoPin(toTopLayoutGuideOf: self, withInset: 20)
        self.selectedTraplinesView.autoPinEdge(toSuperviewEdge: .left)
        self.selectedTraplinesView.autoPinEdge(toSuperviewEdge: .right)
        self.selectedTraplinesView.autoSetDimension(.height, toSize: 40)
        
        self.selectedTraplinesText.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(0, 20, 0, 0), excludingEdge: .right)
        
        self.visitButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(0, 0, 0, 20), excludingEdge: .left)
        self.visitButton.autoSetDimension(.width, toSize: 200)
        
        self.tableView.autoPinEdge(.top, to: .bottom, of: self.selectedTraplinesText, withOffset: 20)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom)
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
    
    func setVisitButtonState(enabled: Bool) {
        visitButton.isEnabled = enabled
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
