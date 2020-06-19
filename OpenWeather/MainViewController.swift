//
//  ViewController.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

import MapKit

class ViewController: UIViewController {
    var locationManager = LocationManager()
    var networkManager: WeatherProviderProtocol = OpenWeatherNetworkManager()
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var parametrsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherIconImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) 
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor? = .black
        locationManager.startLocation { (coorinate) in
            self.networkManager.getDailyWeather(by: coorinate) { (dailyForecast) in
                self.navigationItem.title = dailyForecast.cityName
                self.sunriseLabel.text = dailyForecast.sunrise
                self.sunsetLabel.text = dailyForecast.sunset
                self.visibilityLabel.text = dailyForecast.visibility
                self.temperatureLabel.text = dailyForecast.temperature
                self.windLabel.text = dailyForecast.wind
                self.parametrsLabel.text = dailyForecast.paramets
                self.weatherIconImage.load(url: URL(string: dailyForecast.imageUrl)!)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
}


