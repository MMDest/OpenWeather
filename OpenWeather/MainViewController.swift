//
//  ViewController.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit
import GooglePlaces

// Warning: Додай пробіли між методами і різними типами змінних
class MainViewController: UIViewController {
    var locationManager = LocationManager()
    var networkManager: WeatherProviderProtocol = OpenWeatherNetworkManager()
    var cityCoordinate: Coordinate? = nil
    var searchController = SearchController()
    var cityList: CityList?
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var parametrsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showSearchBarAction(_ sender: Any) {
        searchController = SearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .systemIndigo
        searchController.delegat = self
        self.present(searchController, animated: true, completion: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            locationManager.startLocation { (coordinate) in
                self.setLabelByCoordinate(coordinate: coordinate,city: "")
            }

    }
    fileprivate func setLabelByCoordinate(coordinate:Coordinate, city: String){
        self.networkManager.getDailyWeather(by: coordinate) { (dailyForecast) in
            
            
            self.sunriseLabel.text = dailyForecast.sunrise
            self.sunsetLabel.text = dailyForecast.sunset
            self.visibilityLabel.text = dailyForecast.visibility
            self.temperatureLabel.text = dailyForecast.temperature
            self.windLabel.text = dailyForecast.wind
            self.parametrsLabel.text = dailyForecast.paramets
            guard let url = URL(string: dailyForecast.imageUrl) else {
            return
            }
            self.weatherIconImage.load(url: url)
            guard city == "" else {
                self.navigationItem.title = city
                return
            }
            self.navigationItem.title = dailyForecast.cityName
        }
    }
    
}
extension MainViewController: BackToMainVCDelegat {

    
    func update(coordinate: Coordinate, city: String) {
        self.setLabelByCoordinate(coordinate: coordinate,city: city)
//        self.navigationItem.title = city
    }
}


