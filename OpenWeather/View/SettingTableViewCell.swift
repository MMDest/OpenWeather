//
//  SettingTableViewCell.swift
//  OpenWeather
//
//  Created by MineDest on 7/9/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class UnitsSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var settingControll: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func settingValueChanged(_ sender: UISegmentedControl) {

        if UnitsOptions.distance.description == settingName.text {
            UserDefaults.standard.set(UnitsOptions.distance.units[sender.selectedSegmentIndex],
                                      forKey: UnitsOptions.distance.description)
        } else {
            UserDefaults.standard.set(UnitsOptions.temperature.units[sender.selectedSegmentIndex],
                                      forKey: UnitsOptions.temperature.description)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        settingControll.setTitleTextAttributes(titleTextAttributes, for: .selected)
        settingControll.selectedSegmentTintColor = .systemIndigo
        // Configure the view for the selected state
    }

}
