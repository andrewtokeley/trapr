//
//  VisitLogView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

enum StepperType {
    case eaten
    case removed
    case added
}

/// Extend the Visit to include View specific details
class VisitViewModel: Visit {
    
    convenience init(visit: Visit) {
        self.init(date: visit.visitDateTime, routeId: visit.routeId, traplineId: visit.traplineId, stationId: visit.stationId, trapTypeId: visit.trapTypeId)
        
        // copy all the other properties
        self.id = self.id
        self.baitAdded = visit.baitAdded
        self.baitEaten = visit.baitEaten
        self.baitRemoved = visit.baitRemoved
        self.lureId = visit.lureId
        self.notes = visit.notes
        self.speciesId = visit.speciesId
        self.userId = visit.userId
        self.trapOperatingStatusId = visit.trapOperatingStatusId
        self.trapSetStatusId = visit.trapSetStatusId
    }
    
    var lureName: String?
    var speciesName: String?
}

//MARK: VisitLogView Class
final class VisitLogView: UserInterface {
    
    var delegate: VisitLogViewDelegate?
    
    fileprivate var visit: VisitViewModel?
    
    fileprivate let SECTION_DATETIME = 0
    fileprivate let ROW_DATETIME = 0
    fileprivate let ROW_TRAP_OPERATING_STATUS = 1
    
    fileprivate let SECTION_CATCH = 1
    fileprivate let ROW_TRAP_SET_STATUS = 0
    fileprivate let ROW_CATCH = 1

    fileprivate let SECTION_BAIT = 2
    fileprivate let ROW_BAIT_OPENING = 0
    fileprivate let ROW_BAIT_EATEN = 1
    fileprivate let ROW_BAIT_REMOVED = 2
    fileprivate let ROW_BAIT_ADDED = 3
    fileprivate let ROW_BAIT_BALANCE = 4
    
    fileprivate let SECTION_COMMENTS = 3
    fileprivate let ROW_COMMENTS = 0
    
    fileprivate let SECTION_REMOVE = 4
    fileprivate let ROW_REMOVE = 0
    
    fileprivate let STEPPER_ADD = 0
    fileprivate let STEPPER_EATEN = 1
    fileprivate let STEPPER_REMOVED = 2
    
    fileprivate var sections = [String]()
    fileprivate var visibleSections = [Int]()
    fileprivate var editingComments: Bool = false
    fileprivate var lureBalanceMessage: String?
    
    fileprivate let BAITHEADER_LURETYPE = 11
    
    //MARK: - SubViews
    
    lazy var baitHeaderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        
        let title = UILabel()
        title.text = "BAIT"
        title.font = UIFont.preferredFont(forTextStyle: .footnote)
        title.textColor = UIColor.trpDefaultTableViewHeaderFooter
        
        view.addSubview(title)
        title.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        title.autoPinEdge(toSuperviewEdge: .bottom, withInset: -5)
        title.autoSetDimension(.width, toSize: 100)
        title.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        let lureTypeButton = UIButton()
        lureTypeButton.setTitle("-", for: .normal)
        lureTypeButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        lureTypeButton.setTitleColor(.trpHighlightColor, for: .normal)
        
        lureTypeButton.addTarget(self, action: #selector(lureTypeButtonClick(sender:)), for: .touchUpInside)
        lureTypeButton.contentHorizontalAlignment = .right
        lureTypeButton.tag = BAITHEADER_LURETYPE
        //lureTypeButton.backgroundColor = .red
        
        view.addSubview(lureTypeButton)
        lureTypeButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        lureTypeButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: -5)
        lureTypeButton.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        return view
    }()
    
    lazy var noVisitButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.alpha = 0
        button.setTitle("Record a Visit", for: .normal)
        button.backgroundColor = UIColor.trpHighlightColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(createVisitButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var dateTimeTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Time"
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var trapStatusTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Trap status"
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var trapSetStatusTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Set status"
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    lazy var killTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Species"
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var lureTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Bait used"
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var lureOpeningBalanceTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Opening"
        cell.textLabel?.font = .trpLabelNormalBold
        cell.detailTextLabel?.font = .trpLabelNormalBold
        cell.detailTextLabel?.textColor = .trpTextDark
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var eatenTableViewCell: StepperTableViewCell = {
        let cell = Bundle.main.loadNibNamed("StepperTableViewCell", owner: nil, options: nil)?.first as! StepperTableViewCell
        cell.titleLabel.text = "Eaten"
        cell.titleLabel.textColor = .black
        cell.selectionStyle = .none
        cell.showActionButton(show: false)
        cell.tag = self.STEPPER_EATEN
        cell.delegate = self
        return cell
    }()
    
    lazy var removedTableViewCell: StepperTableViewCell = {
        let cell = Bundle.main.loadNibNamed("StepperTableViewCell", owner: nil, options: nil)?.first as! StepperTableViewCell
        cell.titleLabel.text = "Removed"
        cell.titleLabel.textColor = .black
        cell.selectionStyle = .none
        cell.showActionButton(show: false)
        cell.tag = self.STEPPER_REMOVED
        cell.delegate = self
        return cell
    }()
    
    lazy var addedTableViewCell: StepperTableViewCell = {
        let cell = Bundle.main.loadNibNamed("StepperTableViewCell", owner: nil, options: nil)?.first as! StepperTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = "Added"
        cell.titleLabel.textColor = .black
        cell.showActionButton(show: false)
        cell.tag = self.STEPPER_ADD
        cell.delegate = self
        return cell
    }()
    
    
    lazy var lureClosingBalanceTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Balance"
        cell.textLabel?.font = .trpLabelNormalBold
        cell.detailTextLabel?.font = .trpLabelNormalBold
        cell.detailTextLabel?.textColor = .trpTextDark
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var commentsTableViewCell: CommentsTableViewCell = {
        let cell = Bundle.main.loadNibNamed("CommentsTableViewCell", owner: nil, options: nil)?.first as! CommentsTableViewCell
        cell.selectionStyle = .none
        cell.commentsTextView.delegate = self
        return cell
    }()
    
    lazy var removeVisitButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("Remove Visit", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(removeVisit(sender:)), for: .touchUpInside)
        return button
    }()
        
    //MARK: - UIViewController
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(tableView)
        self.view.addSubview(noVisitButton)
        
        setConstraints()
        
        sections = ["", "CATCH", "BAIT", "COMMENTS", ""]
        visibleSections = [0, 1, 2, 3, 4]
        
        // ensure the keyboard disappears when click view - this also ensures presenter knows about updates to editable fields like comments
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        (tableView as UIScrollView).delegate = self
    }
    
    func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
        
        noVisitButton.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
        noVisitButton.autoAlignAxis(.vertical, toSameAxisOf: self.view)
        noVisitButton.autoSetDimension(.width, toSize: 250)
        noVisitButton.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
    }

    //MARK: - Events
    @objc func stepperAction(sender: UIButton) {
        
    }
    
    @objc func lureTypeButtonClick(sender: UIButton) {
        presenter.didSelectToChangeLure()
    }

    @objc func createVisitButtonClick(sender: UIButton) {
        presenter.didSelectToRecordVisit()
    }

    @objc func removeVisit(sender: UIButton) {
        presenter.didSelectToRemoveVisit()
    }
    
}


//MARK: - UIScrollViewDelegate
extension VisitLogView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //self.delegate?.visitLogViewDidScroll(self, scrollView: scrollView)
    }
}

//MARK: - StepperTableViewCellDelegate

extension VisitLogView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tableView.scrollToRow(at: IndexPath(row: ROW_COMMENTS, section: SECTION_COMMENTS), at: UITableView.ScrollPosition.top, animated: true)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        presenter.didUpdateComment(text: textView.text)
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
        case SECTION_DATETIME: return 2
        case SECTION_CATCH:  return 2 //return self.visit?.speciesId == nil ? 2 : 1
        case SECTION_BAIT: return 5
        case SECTION_COMMENTS: return 1
        case SECTION_REMOVE: return 0
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if visibleSections.contains(section) {
            if section == SECTION_BAIT {
                return sections[section]
            } else {
                return sections[section]
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if visibleSections.contains(section) {
            if section == SECTION_BAIT {
                return lureBalanceMessage
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if visibleSections.contains(indexPath.section) {
            if indexPath.section == SECTION_COMMENTS {
                return LayoutDimensions.tableCellHeight * 2
            } else {
                return tableView.rowHeight
            }
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SECTION_REMOVE {
            return self.removeVisitButton
        } else if section == SECTION_BAIT {
            return self.baitHeaderView
        } else if visibleSections.contains(section) {
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
            if section == SECTION_BAIT {
                return 40 //LayoutDimensions.tableHeaderSectionHeight
            } else {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if visibleSections.contains(section) {
            // add a larger section footer to last section
            if (section == SECTION_REMOVE) {
                return LayoutDimensions.tableFooterSectionHeightLarge + 120
            } else if (section == SECTION_BAIT) && lureBalanceMessage?.count ?? 0 > 0 {
                return LayoutDimensions.tableFooterSectionHeight + 10
            } else {
                return UITableView.automaticDimension //LayoutDimensions.tableFooterSectionHeight
            }
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
            cell.detailTextLabel?.text = self.visit?.visitDateTime.toString(format: "hh:mm") ?? "-"
        } else if section == SECTION_DATETIME && row == ROW_TRAP_OPERATING_STATUS {
            cell = self.trapStatusTableViewCell
            cell.detailTextLabel?.text = self.visit?.trapOperatingStatus.name
        } else if section == SECTION_CATCH && row == ROW_CATCH {
            cell = self.killTableViewCell
            cell.detailTextLabel?.text = self.visit?.speciesName ?? self.visit?.speciesId ?? "None"
        } else if section == SECTION_CATCH && row == ROW_TRAP_SET_STATUS {
            cell = self.trapSetStatusTableViewCell
            cell.detailTextLabel?.text = self.visit?.trapSetStatus?.name ?? "-"
        } else if section == SECTION_BAIT && row == ROW_BAIT_OPENING {
            cell = self.lureOpeningBalanceTableViewCell
        } else if section == SECTION_BAIT && row == ROW_BAIT_ADDED {
            cell = self.addedTableViewCell
            (cell as! StepperTableViewCell).countLabelValue = self.visit?.baitAdded ?? 0
        } else if section == SECTION_BAIT && row == ROW_BAIT_REMOVED {
            cell = self.removedTableViewCell
            (cell as! StepperTableViewCell).countLabelValue = self.visit?.baitRemoved ?? 0
        } else if section == SECTION_BAIT && row == ROW_BAIT_BALANCE {
            cell = self.lureClosingBalanceTableViewCell
        } else if section == SECTION_COMMENTS && row == ROW_COMMENTS {
            cell = self.commentsTableViewCell
            (cell as! CommentsTableViewCell).commentsTextView.text = self.visit?.notes
        } else { // if section == SECTION_BAIT && row == ROW_BAIT_EATEN {
            cell = self.eatenTableViewCell
            (cell as! StepperTableViewCell).countLabelValue = self.visit?.baitEaten ?? 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == SECTION_DATETIME && indexPath.row == ROW_DATETIME {
            presenter.didSelectToChangeTime()
        } else if indexPath.section == SECTION_DATETIME && indexPath.row == ROW_TRAP_OPERATING_STATUS {
            presenter.didSelectToChangeTrapOperatingStatus()
        } else if indexPath.section == SECTION_CATCH && indexPath.row == ROW_TRAP_SET_STATUS {
            presenter.didSelectToChangeTrapSetStatus()
        } else if indexPath.section == SECTION_CATCH && indexPath.row == ROW_CATCH {
            presenter.didSelectToChangeSpecies()
//        } else if indexPath.section == SECTION_BAIT && indexPath.row == ROW_BAIT_TYPE {
//            presenter.didSelectToChangeLure()
        }
    }
    
}

//MARK: - VisitLogView API
extension VisitLogView: VisitLogViewApi {
    
    func displayNoVisitState() {
        self.tableView.alpha = 0
        self.noVisitButton.alpha = 1
    }
    
    func displayVisit(visit: VisitViewModel, showCatchSection: Bool) {
        self.tableView.alpha = 1
        self.noVisitButton.alpha = 0
        
        if let lureTypeButton = self.baitHeaderView.viewWithTag(BAITHEADER_LURETYPE) as? UIButton {
            let text = visit.lureName ?? visit.lureId ?? "None"
            lureTypeButton.setTitle(text, for: .normal)
        }
        
        self.visit = visit
        
        if let index = visibleSections.firstIndex(of: SECTION_CATCH) {
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
        self.dateTimeTableViewCell.detailTextLabel?.text = date.toString(format: "hh:mm")
    }
    
    func displayLureOpeningBalance(balance: Int) {
        //self.lureBalanceMessage = message
        self.lureOpeningBalanceTableViewCell.detailTextLabel?.text = String(balance)
    }

    func displayLureClosingBalance(balance: Int, isOutOfRange: Bool) {
        self.lureClosingBalanceTableViewCell.detailTextLabel?.text = String(balance)
        
        if isOutOfRange {
            self.lureClosingBalanceTableViewCell.detailTextLabel?.textColor = .red
        } else {
            self.lureClosingBalanceTableViewCell.detailTextLabel?.textColor = .trpTextDark
        }
    }

    func displaySpecies(name: String) {
    }

    func setMaxSteppers(eaten: Int, removed: Int, added: Int) {
        
        self.eatenTableViewCell.setMax(maximum: eaten)
        self.removedTableViewCell.setMax(maximum: removed)
        self.addedTableViewCell.setMax(maximum: added)
        
        // make sure the label for added isn't higher than max
        if self.addedTableViewCell.countLabelValue > added {
            self.addedTableViewCell.countLabelValue = added
        }
        
    }
    
    func endEditing() {
        // called by the presenter before navigating away to ensure the active textfield (comments) reports its update
        self.view.endEditing(true)
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
