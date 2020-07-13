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
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
        isSelected = false
        isHighlighted = false
        weekDay?.text = nil
        weatherImageView?.image = nil
        minTemperature?.text = nil
        maxTemperature?.text = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .clear

    }

}
