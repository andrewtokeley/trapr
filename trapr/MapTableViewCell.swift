//
//  MapTableViewCell.swift
//  trapr
//
//  Created by Andrew Tokeley on 21/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class MapTableViewCell: UITableViewCell {

    var showFilter: Bool = false
    var delegate: StationMapViewDelegate?
    
    public lazy var mapView: StationMapView = {
        let view = StationMapView(showFilter: self.showFilter, delegate: delegate!)
        return view
    }()
    
    convenience init(showFilter: Bool, delegate: StationMapViewDelegate) {
        self.init(style: .default, reuseIdentifier: "cell")
        self.showFilter = showFilter
        self.delegate = delegate
        self.contentView.addSubview(mapView)
        mapView.autoPinEdgesToSuperviewEdges()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
