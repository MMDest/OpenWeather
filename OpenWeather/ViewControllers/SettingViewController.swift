//
//  SettingViewController.swift
//  OpenWeather
//
//  Created by MineDest on 7/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Setting"
        tableView.tableFooterView = UIView()
    }

}
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingType.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingType(rawValue: indexPath.section) else { return UITableViewCell()}
        switch section {
        case .general:
            let units = 1
        case .more:
            let units = 1
        case .units:
            guard let units = UnitsOptions(rawValue: indexPath.row) else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "settigCell") as? SettingTableViewCell
            cell?.settingName.text = units.description
            cell?.settingControll.removeAllSegments()
            for settings in units.units {
                cell?.settingControll.insertSegment(withTitle: settings, at: 3, animated: true)
            }
            cell?.settingControll.selectedSegmentIndex = (units.units.firstIndex(of: UserDefaults.standard.string(forKey: units.description)!))!
            print(UserDefaults.standard.string(forKey: units.description)!)
            print((units.units.firstIndex(of: UserDefaults.standard.string(forKey: units.description)!))!)
            return cell!
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = "1"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingType(rawValue: section) else { return ""}
        return section.description
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingType(rawValue: section) else { return 0 }
        switch section {
        case .general:
            return GeneralOptions.allCases.count
        case .more:
            return MoreOptions.allCases.count
        case .units:
            return UnitsOptions.allCases.count
        }
    }
}
