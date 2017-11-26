//
//  VisitLogView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: VisitLogView Class
final class VisitLogView: UserInterface {
    
    fileprivate var visit: Visit?
    
    fileprivate let SECTION_DATETIME = 0
    fileprivate let ROW_DATETIME = 0
    
    fileprivate let SECTION_CATCH = 1
    fileprivate let ROW_CATCH = 0

    fileprivate let SECTION_BAIT = 2
    fileprivate let ROW_BAIT_TYPE = 0
    fileprivate let ROW_ADDED = 1
    fileprivate let ROW_EATEN = 2
    fileprivate let ROW_REMOVED = 3
    
    fileprivate let STEPPER_ADD = 0
    fileprivate let STEPPER_EATEN = 1
    fileprivate let STEPPER_REMOVED = 2
    
    fileprivate var sections = [String]()
    fileprivate var visibleSections = [Int]()
    
    lazy var noVisitButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.alpha = 0
        button.setTitle("Record a Visit", for: .normal)
        button.backgroundColor = UIColor.trpNavigationBar
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(createVisitButtonClick(sender:)), for: .touchUpInside)
        return button
    } ()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    } ()
    
    lazy var dateTimeTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Time"
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var killTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Species"
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var lureTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Type"
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var addedTableViewCell: StepperTableViewCell = {
        let cell = Bundle.main.loadNibNamed("StepperTableViewCell", owner: nil, options: nil)?.first as! StepperTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = "Added"
        cell.tag = self.STEPPER_ADD
        cell.delegate = self
        return cell
    }()
    
    lazy var eatenTableViewCell: StepperTableViewCell = {
        let cell = Bundle.main.loadNibNamed("StepperTableViewCell", owner: nil, options: nil)?.first as! StepperTableViewCell
        cell.titleLabel.text = "Eaten"
        cell.selectionStyle = .none
        cell.tag = self.STEPPER_EATEN
        cell.delegate = self
        return cell
    }()
    
    lazy var removedTableViewCell: StepperTableViewCell = {
        let cell = Bundle.main.loadNibNamed("StepperTableViewCell", owner: nil, options: nil)?.first as! StepperTableViewCell
        cell.titleLabel.text = "Removed"
        cell.selectionStyle = .none
        cell.tag = self.STEPPER_REMOVED
        cell.delegate = self
        return cell
    }()
    
    
//MARK: - UIViewController
    override func loadView() {
        print("loadview")
        super.loadView()
        
        self.view.addSubview(tableView)
        self.view.addSubview(noVisitButton)
        
        setConstraints()
        
        sections = ["", "CATCH", "BAIT"]
        visibleSections = [0, 1, 2]
    }
    
    func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
        
        noVisitButton.autoCenterInSuperview()
        noVisitButton.autoSetDimension(.width, toSize: 200)
        noVisitButton.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
    }

    //MARK: - Events
    
    func createVisitButtonClick(sender: UIButton) {
        presenter.didSelectToRecordVisit()
    }

}


//MARK: - StepperTableViewCellDelegate

extension VisitLogView: StepperTableViewCellDelegate {
    func stepper(_ stepper: StepperTableViewCell, valueChanged: Int) {
        // tell the presenter this happened
        if stepper.tag == STEPPER_ADD {
            presenter.didUpdateBaitAddedValue(newValue: valueChanged)
        }
        if stepper.tag == STEPPER_EATEN {
            presenter.didUpdateBaitEatenValue(newValue: valueChanged)
        }
        
        if stepper.tag == STEPPER_REMOVED {
            presenter.didUpdateBaitRemovedValue(newValue: valueChanged)
        }
        
    }
}

//MARK: - UITableView
extension VisitLogView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 4
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if visibleSections.contains(section) {
            return sections[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if visibleSections.contains(indexPath.section) {
            return tableView.rowHeight
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if visibleSections.contains(section) {
            return tableView.headerView(forSection: section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if visibleSections.contains(section) {
            return tableView.footerView(forSection: section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if visibleSections.contains(section) {
            return tableView.sectionHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if visibleSections.contains(section) {
            return tableView.sectionFooterHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isHidden = !visibleSections.contains(indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        var cell: UITableViewCell
        
        if section == SECTION_DATETIME && row == ROW_DATETIME {
            cell = self.dateTimeTableViewCell
            cell.detailTextLabel?.text = self.visit?.visitDateTime.string(from: "hh:mm") ?? "-"
        } else if section == SECTION_CATCH && row == ROW_CATCH {
            cell = self.killTableViewCell
            cell.detailTextLabel?.text = self.visit?.catchSpecies?.name ?? "None"
        } else if section == SECTION_BAIT && row == ROW_BAIT_TYPE {
            cell = self.lureTableViewCell
            cell.detailTextLabel?.text = self.visit?.lure?.name ?? "-"
        } else if section == SECTION_BAIT && row == ROW_ADDED {
            cell = self.addedTableViewCell
            (cell as! StepperTableViewCell).setCountValue(newValue: self.visit?.baitAdded ?? 0)
        } else if section == SECTION_BAIT && row == ROW_REMOVED {
            cell = self.removedTableViewCell
            (cell as! StepperTableViewCell).setCountValue(newValue: self.visit?.baitRemoved ?? 0)
        } else { // if section == SECTION_BAIT && row == ROW_EATEN {
            cell = self.eatenTableViewCell
            (cell as! StepperTableViewCell).setCountValue(newValue: self.visit?.baitEaten ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == SECTION_DATETIME && indexPath.row == ROW_DATETIME {
            presenter.didSelectToChangeTime()
        } else if indexPath.section == SECTION_CATCH && indexPath.row == ROW_CATCH {
            presenter.didSelectToChangeSpecies()
        } else if indexPath.section == SECTION_BAIT && indexPath.row == ROW_BAIT_TYPE {
            presenter.didSelectToChangeLure()
        }
    }
}

//MARK: - VisitLogView API
extension VisitLogView: VisitLogViewApi {
    
    func displayNoVisitState() {
        self.tableView.alpha = 0
        self.noVisitButton.alpha = 1
    }
    
    func displayVisit(visit: Visit, showCatchSection: Bool) {
        self.tableView.alpha = 1
        self.noVisitButton.alpha = 0
        
        self.visit = visit
        
        if let index = visibleSections.index(of: SECTION_CATCH) {
            visibleSections.remove(at: index)
        }
        if showCatchSection {
            visibleSections.append(SECTION_CATCH)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    func displayDateTime(date: Date) {
        self.dateTimeTableViewCell.detailTextLabel?.text = date.string(from: "hh:mm")
        //presenter.updateDateTime(date: date)
    }
    
    func displaySpecies(name: String) {
        //presenter.`
    }
}

// MARK: - VisitLogView Viper Components API
private extension VisitLogView {
    var presenter: VisitLogPresenterApi {
        return _presenter as! VisitLogPresenterApi
    }
    var displayData: VisitLogDisplayData {
        return _displayData as! VisitLogDisplayData
    }
}
