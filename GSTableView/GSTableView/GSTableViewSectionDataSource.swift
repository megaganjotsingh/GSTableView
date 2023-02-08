//
//  GSTableViewSectionDatasource.swift
//  GSTableView
//
//  Created by Admin on 02/02/23.
//

import Foundation
import UIKit

class GSTableViewSectionDataSource<Section: Hashable, Model: Hashable> {
    var dataSource: (() -> (Section?, [Model]))?
    var dequeReusableCell: ((UITableView, Model) -> (UITableViewCell))?
    var didSelectCell: ((Model) -> ())?
    var titleForSection: (() -> ())?
    var viewForHeaderInSection: (() -> (headerView: UIView, height: CGFloat))?
    
    init(dataSource: (() -> (Section?, [Model]))?, dequeReusableCell: ((UITableView, Model) -> (UITableViewCell))?, didSelectCell: ((Model) -> ())?, titleForSection: (() -> ())? = nil) {
        self.dataSource = dataSource
        self.dequeReusableCell = dequeReusableCell
        self.didSelectCell = didSelectCell
        self.titleForSection = titleForSection
        self.viewForHeaderInSection = viewForHeaderInSection
    }
}
