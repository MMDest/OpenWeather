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
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    lazy var leftBarItemLabel = UILabel(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.searchBar.showsCancelButton = true
//        self.searchBar.barStyle = .black
//        self.searchBar.searchTextField.textColor = .white
//        self.searchBar.tintColor = .white
//        self.searchBar.searchTextField.leftView?.tintColor = .white
//        self.searchBar.searchTextField.textAlignment = .center
//        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) 
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor? = .black
//        self.searchBar.searchTextField.addTarget(self, action: #selector(searchTextFieldIsEditing), for: .editingDidBegin)
        locationManager.startLocation { (coorinate) in
            self.networkManager.getDailyWeather(by: coorinate) { (dailyForecast) in
                self.navigationItem.title = dailyForecast.cityName
//                self.navigationItem.leftBarButtonItem?.title = dailyForecast.cityName
//                self.navigationItem.leftBarButtonItem?.style = .plain
//                self.navigationController?.title = dailyForecast.cityName
//                self.navigationController?.navigationItem.leftBarButtonItem?.title = dailyForecast.cityName
//                self.searchBar.text = dailyForecast.cityName
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
//    @objc func searchTextFieldIsEditing(){
//
//    }
    override func viewWillAppear(_ animated: Bool) {
    }
}


