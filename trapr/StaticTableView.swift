//
//  StaticTableView.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 4/09/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class StaticTableView: UITableView {
    
    var staticTableViewDelegate: StaticTableViewDelegate?
    
    var sections = [StaticSection]()
    
    // MARK: - Initialisers
    
    init(sections: [StaticSection]) {
        super.init(frame: CGRect.zero, style: .grouped)
        self.sections = sections
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Section Functions
    
    public func section(by title: String) -> StaticSection? {
        return sections.first(where: { $0.title == title })
    }
    
    // MARK: - Row Functions
    
    public func row(_ indexPath: IndexPath) -> StaticRow {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    // MARK: - Visibility
    public func setVisibility(sectionTitles: [String], isVisible: Bool) {
        for title in sectionTitles {
            section(by: title)?.isVisible = isVisible
        }
    }
    
}

extension StaticTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].rows[indexPath.row].cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section].isVisible {
            return sections[section].title
        }
        return ""
    }
    
}

extension StaticTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        staticTableViewDelegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isHidden = !sections[indexPath.section].isVisible
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return row(indexPath).height ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sections[section].isVisible {
            return tableView.headerView(forSection: section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if sections[section].isVisible {
            return tableView.footerView(forSection: section)
        }
        return nil
    }
    
}
