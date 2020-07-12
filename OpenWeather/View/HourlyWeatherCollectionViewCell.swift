//
//  HourlyWeatherCollectionViewCell.swift
//  OpenWeather
//
//  Created by MineDest on 7/8/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
        isSelected = false
        isHighlighted = false
        hourLabel?.text = nil
        weatherImageView?.image = nil
        temperatureLabel?.text = nil
    }
}
