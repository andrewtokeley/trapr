//
//  VisitHistoryView.swift
//  trapr
//
//  Created by Andrew Tokeley on 1/02/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: VisitHistoryView Class
final class VisitHistoryView: UserInterface {
    fileprivate var visitSummaries = [VisitSummary]()
    fileprivate let CELL_REUSE_ID = "cell"
    fileprivate var selectedRow: IndexPath?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        let nibcell = UINib(nibName: "VisitSummaryTableViewCell", bundle: nil)
        tableView.register(nibcell, forCellReuseIdentifier: self.CELL_REUSE_ID)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView

    }()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
}

//MARK: - UITableView
extension VisitHistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return visitSummaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_REUSE_ID, for: indexPath) as! VisitSummaryTableViewCell
        
        let visit = self.visitSummaries[indexPath.section]
        cell.titleLabel.text = visit.dateOfVisit.toString(format: "dd MMM, yyyy")
        cell.timeTakenLabel.text = visit.timeTaken.formatInTimeUnits()
        
        var stats = [Statistic]()
        stats.append(Statistic(title: "POISON", statistic: String(visit.totalPoisonAdded), variance: -5.0))
        
        var count = 0
        var otherCount = 0
        for kills in visit.totalKillsBySpecies {
            if count < 2 {
                stats.append(Statistic(title: kills.key, statistic: String(kills.value), variance: -5.0))
            } else {
               otherCount += kills.value
            }
            count += 1
            
            if count == visit.totalKillsBySpecies.count && otherCount != 0 {
                stats.append(Statistic(title: "Other", statistic: String(otherCount), variance: -5.0))
            }
            
        }
        
        cell.statistics = stats

        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = self.tableView(tableView, heightForHeaderInSection: section)
        let view = UIView(frame: CGRect(x: 0, y: 0, width:  self.view.frame.size.width, height: height))
        //view.backgroundColor = UIColor.red
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let height = self.tableView(tableView, heightForFooterInSection: section)
        let view = UIView(frame: CGRect(x: 0, y: 0, width:  self.view.frame.size.width, height: height))
        //view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? LayoutDimensions.spacingMargin * 2 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return LayoutDimensions.smallSpacingMargin
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath
        presenter.didSelectVisitSummary(visitSummary: self.visitSummaries[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        let kCellActionWidth = CGFloat(120.0)// The width you want of delete button
//        let kCellHeight = tableView.frame.size.height // The height you want of delete button
//        let whitespace = whitespaceString(width: kCellActionWidth) // add the padding
        
        
        let deleteAction = UITableViewRowAction(style: .`default`, title: "Delete") {_,_ in
            // do whatever the action you want
            self.presenter.didSelectDeleteVisitSummary(visitSummary: self.visitSummaries[indexPath.section])
        }
//
//        // create a color from patter image and set the color as a background color of action
//        let view = UIView(frame: CGRect(x: tableView.frame.size.width-kCellActionWidth, y: 0, width: kCellActionWidth, height: kCellHeight))
//        view.backgroundColor = UIColor.red
//        let imageView = UIImageView(frame: CGRect(x: 10,
//                                                  y: 10,
//                                                  width: 20,
//                                                  height: 20))
//        imageView.image = UIImage(named: "settings")! // required image
//        view.addSubview(imageView)
//        let image = view.image()
//
//        deleteAction.backgroundColor = UIColor.init(patternImage: image)
        return [deleteAction]
    }
    
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 20
        let mutable = NSMutableString(string: "")
        let attribute = [NSAttributedStringKey.font: font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
}

//MARK: - VisitHistoryView API
extension VisitHistoryView: VisitHistoryViewApi {
    func displayVisitSummaries(visitSummaries: [VisitSummary], fullReload: Bool) {
        self.visitSummaries = visitSummaries
        if fullReload {
            self.tableView.reloadData()
        } else {
            if let sectionToRefresh = self.selectedRow?.section {
                tableView.reloadSections([sectionToRefresh], with: .none)
            }
        }
    }
}

// MARK: - VisitHistoryView Viper Components API
private extension VisitHistoryView {
    var presenter: VisitHistoryPresenterApi {
        return _presenter as! VisitHistoryPresenterApi
    }
    var displayData: VisitHistoryDisplayData {
        return _displayData as! VisitHistoryDisplayData
    }
}
