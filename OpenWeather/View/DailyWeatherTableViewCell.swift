//
//  HourlyWeatherTableViewCell.swift
//  OpenWeather
//
//  Created by MineDest on 7/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        minTemperature.textColor = (minTemperature?.textColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .clear

    }

}
