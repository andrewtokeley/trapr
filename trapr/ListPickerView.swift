//
//  ListPickerView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: ListPickerView Class
final class ListPickerView: UserInterface {
    
    fileprivate let CELL_ID = "cell"
    
    lazy var tableView: UITableView = {
       
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()

        self.title = displayData.delegate?.listPicker(title: self)
        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges(with: .zero)
    }
    
}

//MARK: - UITableView
extension ListPickerView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayData.delegate?.listPicker(numberOfRows: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = displayData.delegate?.listPicker(self, itemTextAtRow: indexPath.row)
        cell.detailTextLabel?.text = displayData.delegate?.listPicker(self, itemDetailAtRow: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return displayData.delegate?.listPicker(headerText: self)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayData.delegate?.listPicker(self, didSelectItemAtRow: indexPath.row)
        presenter.didSelectItem(row: indexPath.row)
    }
    
}

//MARK: - ListPickerView API
extension ListPickerView: ListPickerViewApi {
    
    var tag: Int { return self.view.tag }
    
    func setTag(tag: Int) {
        self.view.tag = tag
    }
    
    func setTitle(title: String) {
        self.title = title
    }
}

// MARK: - ListPickerView Viper Components API
private extension ListPickerView {
    var presenter: ListPickerPresenterApi {
        return _presenter as! ListPickerPresenterApi
    }
    var displayData: ListPickerDisplayData {
        return _displayData as! ListPickerDisplayData
    }
}
