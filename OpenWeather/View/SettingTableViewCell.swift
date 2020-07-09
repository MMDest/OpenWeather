//
//  SettingTableViewCell.swift
//  OpenWeather
//
//  Created by MineDest on 7/9/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingName: UILabel!
    @IBOutlet weak var settingControll: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
