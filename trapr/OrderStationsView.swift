//
//  OrderStationsView.swift
//  trapr
//
//  Created by Andrew Tokeley on 31/01/19.
//Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

struct StationViewModel {
    var stationNames: [String]
}

//MARK: OrderStationsView Class
final class OrderStationsView: UserInterface {
    
    fileprivate var viewModel: StationViewModel?
    
    /// Cell ID for UITableView
    fileprivate let CELL_ID = "cell"
    
    //MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        return tableView
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Drag rows to change the order you visit stations."
        label.font = UIFont.trpLabelSmall
        label.textColor = UIColor.trpTextDark
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        
        self.view.addSubview(instructionsLabel)
        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        instructionsLabel.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        instructionsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        instructionsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        
        tableView.autoPinEdge(.top, to: .bottom, of: instructionsLabel, withOffset: LayoutDimensions.spacingMargin)
        tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
    }
    
    //MARK: Events
    
    @objc func doneButtonClick(sender: UIButton) {
        presenter.didSelectDone()
    }
}

//MARK: - TableView
extension OrderStationsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        presenter.didMoveStation(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.stationNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        cell.textLabel?.text = self.viewModel?.stationNames[indexPath.row]
        
        return cell
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

//MARK: - OrderStationsView API
extension OrderStationsView: OrderStationsViewApi {
    
    func updateViewModel(viewModel: StationViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - OrderStationsView Viper Components API
private extension OrderStationsView {
    var presenter: OrderStationsPresenterApi {
        return _presenter as! OrderStationsPresenterApi
    }
    var displayData: OrderStationsDisplayData {
        return _displayData as! OrderStationsDisplayData
    }
}
