//
//  GSTableView.swift
//  GSTableView
//
//  Created by Admin on 02/02/23.
//

import Foundation
import UIKit

class GSTableView: UITableView {
    private var snapShot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
    private var tableDataSource: UITableViewDiffableDataSource<AnyHashable, AnyHashable>?
    
    var datasources: (() -> ([GSTableViewSectionDataSource<AnyHashable, AnyHashable>]))?
    
    convenience init() {
        self.init(frame: .zero)
        setUpView()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    /// cell registration method
    func registerCell(_ cell: UITableViewCell.Type) {
        let string = String(describing: cell.self)
        register(cell.self, forCellReuseIdentifier: string)
        separatorStyle = .none
    }

    func setUpView() {
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    func createDataSource() -> UITableViewDiffableDataSource<AnyHashable, AnyHashable>? {
        guard let allDatasource = datasources?() else { return nil }
        tableDataSource = UITableViewDiffableDataSource<AnyHashable, AnyHashable>(tableView: self, cellProvider: { [weak self] tableV, indexPath, model in
            guard let self = self else { return UITableViewCell() }
            return allDatasource[indexPath.section].dequeReusableCell?(self, model) ?? UITableViewCell()
            
        })
        return tableDataSource
    }
    
    func setDataSource() {
        dataSource = createDataSource()
        delegate = self
        applyChanges()
    }
    
    func applyChanges() {
        configureSnapshot()
    }
    
    func configureSnapshot() {
        var snapShotsss = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        guard let allDatasource = datasources?() else { return }
        allDatasource.forEach({ sectionDataSource in
            let dataSource = sectionDataSource.dataSource
            snapShotsss.appendSections([dataSource?().0])
            snapShotsss.appendItems(dataSource?().1 ?? [], toSection: dataSource?().0)
        })
        tableDataSource?.apply(snapShotsss)
    }
}

extension GSTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let allDatasource = datasources?() else { return }
        allDatasource[indexPath.section].didSelectCell?(allDatasource[indexPath.section].dataSource?().1[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let allDatasource = datasources?() else { return nil }
        return allDatasource[section].viewForHeaderInSection?().headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let allDatasource = datasources?() else { return 0 }
        return allDatasource[section].viewForHeaderInSection?().height ?? 0
    }
}
