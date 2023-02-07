//
//  GSTableView.swift
//  GSTableView
//
//  Created by Admin on 02/02/23.
//

import Foundation
import UIKit

class GSTableView: UIView {
    private var tableView: UITableView!
    private var snapShot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
    private var tableDataSource: UITableViewDiffableDataSource<AnyHashable, AnyHashable>?
    
    var datasource: (() -> ([GSTableViewSectionDataSource<AnyHashable, AnyHashable>]))?
    
    convenience init() {
        self.init(frame: .zero)
        setUpView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    func registerCell(_ cell: UITableViewCell.Type) {
        let string = String(describing: cell.self)
        tableView.register(cell.self, forCellReuseIdentifier: string)
        tableView.separatorStyle = .none
    }

    func setUpView() {
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        align()
    }

    func align() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
    
    func createDataSource() -> UITableViewDiffableDataSource<AnyHashable, AnyHashable>? {
        guard let allDatasource = datasource?() else { return nil }
        tableDataSource = UITableViewDiffableDataSource<AnyHashable, AnyHashable>(tableView: tableView, cellProvider: { [weak self] tableV, indexPath, model in
            guard let self = self else { return nil }
            return allDatasource[indexPath.section].dequeReusableCell?(self.tableView, model) ?? UITableViewCell()
            
        })
        return tableDataSource
    }
    
    func setDataSource() {
        tableView.dataSource = createDataSource()
        tableView.delegate = self
        applyChanges()
    }
    
    func applyChanges() {
        configureSnapshot()
//        tableDataSource?.apply(snapShot)
    }
    
    func configureSnapshot() {
        var snapShotsss = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        guard let allDatasource = datasource?() else { return }
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
        guard let allDatasource = datasource?() else { return }
        allDatasource[indexPath.section].didSelectCell?(allDatasource[indexPath.section].dataSource?().1[indexPath.row])
    }
}
