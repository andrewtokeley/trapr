//
//  TrapStatisticsView.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/07/20.
//Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: TrapStatisticsView Class
final class TrapStatisticsView: UserInterface {
    
    fileprivate var hasCatches = false
    fileprivate var hasVisits = false
    
    fileprivate let ROW_TAG_TOTALCATCHES = 100
    fileprivate let ROW_TAG_TOTALVISITS = 101
    
    fileprivate enum Sections: Int {
        case totalVisits = 0
        case catches = 1
        case trapSetStatus = 2
        case baitCounts = 3
        
        static var count = 4
        
        var name: String {
            switch self {
            case .totalVisits: return ""
            case .catches: return "CATCHES"
            case .trapSetStatus: return "TRAP SET STATUS"
            case .baitCounts: return "BAIT"
            }
        }
    }

    // MARK: Constants
    fileprivate var visibleSections = [
        Sections.totalVisits: true,
        Sections.catches: true,
        Sections.trapSetStatus: true,
        Sections.baitCounts: true
    ]
    
    fileprivate var SECTION_ROWS = [[UITableViewCell]]()
    
    
    // MARK: SubViews
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        //tableView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var totalVisitsTableViewCell: TableViewCellStyleValue3 = {
        let cell = Bundle.main.loadNibNamed("TableViewCellStyleValue3", owner: nil, options: nil)?.first as! TableViewCellStyleValue3
        cell.leftTextLabel.text = "Visits"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        cell.tag = ROW_TAG_TOTALVISITS
        
        return cell
    }()
    
    lazy var totalCatchesTableViewCell: TableViewCellStyleValue3 = {
        let cell = Bundle.main.loadNibNamed("TableViewCellStyleValue3", owner: nil, options: nil)?.first as! TableViewCellStyleValue3
        cell.leftTextLabel.text = "Total"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        cell.tag = ROW_TAG_TOTALCATCHES
        
        return cell
    }()
    
    lazy var catchRateTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Catch Rate"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var trapSetStatus_stillSet_TableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = TrapSetStatus.stillSet.name
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var trapSetStatus_stillSetBaitEaten_TableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = TrapSetStatus.setBaitEaten.name
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var trapSetStatus_sprungAndEmpty_TableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = TrapSetStatus.sprungAndEmpty.name
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var trapSetStatus_trapGone_TableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = TrapSetStatus.trapGone.name
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var trapSetStatus_notSet_TableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Not set"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var baitEatenTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Eaten"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var baitRemovedTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Removed"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    var baitAddedTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Added"
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }()
    
    //MARK: UIViewController
    override func loadView() {
        
        super.loadView()
        
        // define section rows
        SECTION_ROWS = [
            [
                totalVisitsTableViewCell
            ],
            [
                totalCatchesTableViewCell,
                catchRateTableViewCell
            ],
            [
                trapSetStatus_stillSet_TableViewCell,
                trapSetStatus_sprungAndEmpty_TableViewCell,
                trapSetStatus_stillSetBaitEaten_TableViewCell,
                trapSetStatus_trapGone_TableViewCell,
                trapSetStatus_notSet_TableViewCell
            ],
            [
                baitEatenTableViewCell,
                baitRemovedTableViewCell,
                baitAddedTableViewCell
            ]
        ]
        
        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
}

extension TrapStatisticsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sectionEnum = Sections(rawValue: section) {
            if visibleSections[sectionEnum]! {
                return sectionEnum.name
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionEnum = Sections(rawValue: indexPath.section) {
            if visibleSections[sectionEnum]! {
                // check if this is a Value3 cell
                if let cell = SECTION_ROWS[indexPath.section][indexPath.row] as? TableViewCellStyleValue3 {
                    
                    // with data the Value3 type cell needs more height
                    if (cell.tag == ROW_TAG_TOTALVISITS && hasVisits) ||
                        (cell.tag == ROW_TAG_TOTALCATCHES && hasCatches)
                        {
                        return LayoutDimensions.tableCellHeight * 1.5
                    }
                    return UITableView.automaticDimension
                } else {
                    return UITableView.automaticDimension
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionEnum = Sections(rawValue: section) {
            if visibleSections[sectionEnum]! {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let sectionEnum = Sections(rawValue: section) {
            if visibleSections[sectionEnum]! {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionEnum = Sections(rawValue: section) {
            if visibleSections[sectionEnum]! {
                return tableView.headerView(forSection: section)
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let sectionEnum = Sections(rawValue: section) {
            if visibleSections[sectionEnum]! {
                return tableView.footerView(forSection: section)
            }
        }
        return nil
    }
}

extension TrapStatisticsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SECTION_ROWS[section].count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let sectionEnum = Sections(rawValue: indexPath.section) {
            cell.isHidden = !visibleSections[sectionEnum]!
        } else {
            cell.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SECTION_ROWS[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
}

//MARK: - TrapStatisticsView API
extension TrapStatisticsView: TrapStatisticsViewApi {
    
    func displayStatistics(statistics: TrapStatistics, showCatchStats: Bool) {
        
        self.hasVisits = statistics.numberOfVisits > 0
        self.hasCatches = statistics.totalCatches > 0
        
        visibleSections[Sections.catches] = showCatchStats
        visibleSections[Sections.baitCounts] = !showCatchStats
        visibleSections[Sections.trapSetStatus] = showCatchStats
        
        // total visits
        totalVisitsTableViewCell.rightTextLabel?.text = String(statistics.numberOfVisits)
        
        // last visit
        totalVisitsTableViewCell.subtextLabel.text = ""
        if let lastVisitedDate = statistics.lastVisit?.visitDateTime {
            totalVisitsTableViewCell.subtextLabel.text = "last visited \( lastVisitedDate.daysSinceDescription())"
        }
        
        // total catches
        totalCatchesTableViewCell.rightTextLabel?.text = String(statistics.totalCatches)
        
        // last catch
        totalCatchesTableViewCell.subtextLabel?.text = ""
        if let speciesId = statistics.visitsWithCatches.first?.speciesId {
            if let speciesCode = SpeciesCode(rawValue: speciesId) {
                let date = statistics.visitsWithCatches.first!.visitDateTime
                let dateText = date.toString(format: Styles.DATE_FORMAT_LONG)
                let daysAgoText = date.daysSinceDescription()
                totalCatchesTableViewCell.subtextLabel?.text = "Last catch, \(speciesCode), \(dateText) (\(daysAgoText))"
            }
        }

        
        
        // catch rate
        if let rate = statistics.catchRate {
            catchRateTableViewCell.detailTextLabel?.text = "\(Int(rate * Double(100)))%"
        } else {
            catchRateTableViewCell.detailTextLabel?.text = "0%"
        }
        
        // trap set status...
        var stillSet:Double = 0
        if statistics.numberOfVisits > 0 {
            stillSet = Double(statistics.trapSetStatusCounts[TrapSetStatus.stillSet.rawValue] ?? 0) / Double(statistics.numberOfVisits) * 100
        }
        trapSetStatus_stillSet_TableViewCell.detailTextLabel?.text = "\(String(format: "%.0f", stillSet))%"

        var stillSetBaitEaten:Double = 0
        if statistics.numberOfVisits > 0 {
            stillSetBaitEaten = Double(statistics.trapSetStatusCounts[TrapSetStatus.setBaitEaten.rawValue] ?? 0) / Double(statistics.numberOfVisits) * 100
        }
        trapSetStatus_stillSetBaitEaten_TableViewCell.detailTextLabel?.text = "\(String(format: "%.0f", stillSetBaitEaten))%"

        var sprungEmpty:Double = 0
        if statistics.numberOfVisits > 0 {
            sprungEmpty = Double(statistics.trapSetStatusCounts[TrapSetStatus.sprungAndEmpty.rawValue] ?? 0) / Double(statistics.numberOfVisits) * 100
        }
        trapSetStatus_sprungAndEmpty_TableViewCell.detailTextLabel?.text = "\(String(format: "%.0f", sprungEmpty))%"
        
        var trapGone:Double = 0
        if statistics.numberOfVisits > 0 {
            trapGone = Double(statistics.trapSetStatusCounts[TrapSetStatus.trapGone.rawValue] ?? 0) / Double(statistics.numberOfVisits) * 100
        }
        trapSetStatus_trapGone_TableViewCell.detailTextLabel?.text = "\(String(format: "%.0f", trapGone))%"
        
        //let totalCounts = statistics.trapSetStatusCounts.reduce(0) { $0 + $1.value }
        let notSet = 100 - (Int(stillSet) + Int(stillSetBaitEaten) + Int(sprungEmpty) +
        Int(trapGone))
        trapSetStatus_notSet_TableViewCell.detailTextLabel?.text = "\(notSet)%"
        
        // Bait
        baitEatenTableViewCell.detailTextLabel?.text = String(statistics.baitEaten)
        baitRemovedTableViewCell.detailTextLabel?.text = String(statistics.baitRemoved)
        baitAddedTableViewCell.detailTextLabel?.text = String(statistics.baitAdded)
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
}

// MARK: - TrapStatisticsView Viper Components API
private extension TrapStatisticsView {
    var presenter: TrapStatisticsPresenterApi {
        return _presenter as! TrapStatisticsPresenterApi
    }
    var displayData: TrapStatisticsDisplayData {
        return _displayData as! TrapStatisticsDisplayData
    }
}