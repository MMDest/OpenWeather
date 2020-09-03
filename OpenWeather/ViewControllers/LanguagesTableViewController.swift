//
//  LanguagesTableViewController.swift
//  OpenWeather
//
//  Created by MineDest on 7/13/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class LanguagesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Languages"
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return GeneralOptions.language.languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = GeneralOptions.language.languages[indexPath.row]
        guard cell.textLabel?.text !=  UserDefaults.standard.string(forKey: "Language") else {
//            cell.isSelected = true
            cell.accessoryType = .checkmark
            return cell
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = GeneralOptions.language.languages[indexPath.row]
        UserDefaults.standard.set(language, forKey: "Language")
        navigationController?.popViewController(animated: true)
    }
}
