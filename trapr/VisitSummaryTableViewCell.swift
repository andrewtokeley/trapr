//
//  VisitSummaryTableViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 27/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

struct Statistic {
    var title: String?
    var statistic: String?
    var variance: Double = 0
}

class VisitSummaryTableViewCell: UITableViewCell {
    let CELL_IDENTIFIER = "cell"
    //var delegate: VisitSummaryTableViewCellDelegate?
    
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statisticsCollectionView: UICollectionView!
    
    var statistics = [Statistic]() {
        didSet {
            statisticsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        titleLabel.font = UIFont.trpLabelNormal
        titleLabel.textColor = UIColor.trpTextHighlight
        
        timeTakenLabel.font = UIFont.trpLabelNormal
        timeTakenLabel.textColor = UIColor.darkGray
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: LayoutDimensions.spacingMargin, bottom: 0, right: LayoutDimensions.spacingMargin)
        layout.footerReferenceSize = CGSize.zero
        layout.headerReferenceSize = CGSize.zero
        
        statisticsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.CELL_IDENTIFIER)
        statisticsCollectionView.collectionViewLayout = layout
        
    }
    
}

extension VisitSummaryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        var statisticView: StatisticView?
        statisticView = cell.viewWithTag(100) as? StatisticView
        if statisticView == nil {
            statisticView = Bundle.main.loadNibNamed("StatisticView", owner: nil, options: nil)?.first as? StatisticView
            statisticView?.tag = 100
            
            cell.contentView.addSubview(statisticView!)
            statisticView?.autoPinEdgesToSuperviewEdges()
        }
        
        statisticView?.heading = self.statistics[indexPath.row].title?.uppercased()
        statisticView?.statistic = self.statistics[indexPath.row].statistic
        statisticView?.showDivider(show: indexPath.row != statistics.count - 1)
        
        return cell
    }
    
}

