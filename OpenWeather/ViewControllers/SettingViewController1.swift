//
//  SettingViewController.swift
//  OpenWeather
//
//  Created by MineDest on 7/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class SettingViewController1: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    var tableView:UITableView?
    var delegat: BackToMainVCDelegat?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        navigationItem.title = "Setting"

    }
    override func viewWillAppear(_ animated: Bool) {
        tableView?.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegat?.uppdate()
    }

}
extension SettingViewController1: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingType.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingType(rawValue: indexPath.section) else { return UITableViewCell()}
        switch section {
        case .general:
            guard let general = GeneralOptions(rawValue: indexPath.row) else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "generalSettingCell")
            cell?.textLabel?.text = general.description
            cell?.detailTextLabel?.text = UserDefaults.standard.string(forKey: "Language")
            return cell ?? UITableViewCell()
        case .more:
            guard let more = MoreOptions(rawValue: indexPath.row) else {return UITableViewCell()}
//            let cell = tableView.dequeueReusableCell(withIdentifier: "moreSettingCell")
            let cell = UITableViewCell()
            cell.textLabel?.text = more.description
            return cell ?? UITableViewCell()
        case .units:
            guard let units = UnitsOptions(rawValue: indexPath.row) else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "unitsSettingCell") as? UnitsSettingTableViewCell
            cell?.settingName.text = units.description
            cell?.settingControll.removeAllSegments()
            for settings in units.units {
                cell?.settingControll.insertSegment(withTitle: settings, at: 3, animated: true)
            }
            let index = UserDefaults.standard.string(forKey: units.description) ?? ""
            cell?.settingControll.selectedSegmentIndex = units.units.firstIndex(of: index) ?? 0
            return cell ?? UITableViewCell()
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingType(rawValue: indexPath.section) else { return }
        switch section {
        case .general:
            self.addChild(LanguagesTableViewController())
            self.navigationController?.pushViewController(LanguagesTableViewController(), animated: true)
        case .units:
            return
        case .more:
            return
        }
    }

}
