//
//  ViewController.swift
//  GSTableView
//
//  Created by Admin on 02/02/23.
//

import UIKit

protocol asdd: Hashable { }

struct Car: Hashable {
    let name: String
}

struct Bus: Hashable {
    let name: String
}

struct Truck: Hashable {
    let name: String
}

enum Sectionsss: String, CaseIterable, Hashable {
    case car
    case bus
    case truck
}

class ViewController: UIViewController {
    var tableView = GSTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        align()
        setUpDataSource()
    }

    func align() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func setUpDataSource() {
        let cellDescriptor: ((UITableView, AnyHashable) -> (UITableViewCell)) = { table, caar in
                var cell = table.dequeueReusableCell(withIdentifier: "CarCell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "CarCell")
                }
                cell?.textLabel?.text = (caar as? Car)?.name
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 40)
                print(caar.base)
                return cell ?? UITableViewCell()
            }
            
        let carSectionDataSource = GSTableViewSectionDataSource<AnyHashable, AnyHashable>(
            dataSource: {
                return (
                    AnyHashable(Sectionsss.car),
                    [
                        AnyHashable(Car(name: "Audi")),
                        AnyHashable(Car(name: "BMW")),
                        AnyHashable(Car(name: "Maercedies"))
                    ]
                )
            },
            dequeReusableCell: cellDescriptor, didSelectCell: { model in
                print(model)
            }
        )
        
        let busSectionDataSource = GSTableViewSectionDataSource<AnyHashable, AnyHashable>(
            dataSource: {
                return (
                    AnyHashable(Sectionsss.bus),
                    [
                        AnyHashable(Bus(name: "volvo")),
                        AnyHashable(Bus(name: "Roadways")),
                        AnyHashable(Bus(name: "Maercedies"))
                    ]
                )
            },
            dequeReusableCell: { table, caar in
                var cell = table.dequeueReusableCell(withIdentifier: "BusCell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "BusCell")
                }
                cell?.textLabel?.text = (caar as? Bus)?.name
                print(caar.base)
                return cell ?? UITableViewCell()
            }, didSelectCell: { model in
                print(model)
            }
        )
        
        tableView.datasource = {
            return [carSectionDataSource, busSectionDataSource]
        }
        tableView.setDataSource()
        tableView.applyChanges()
    }
}
