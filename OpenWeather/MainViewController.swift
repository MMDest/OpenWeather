//
//  ViewController.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

// Warning: Додай пробіли між методами і різними типами змінних
class MainViewController: UIViewController {
    var locationManager = LocationManager()
    var networkManager: WeatherProviderProtocol = OpenWeatherNetworkManager()
    var cityCoordinate: Coordinate? = nil
    var searchController: UISearchController!
    var cityList: CityList?
    var cityListTableView: UITableView!

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
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .systemIndigo
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.2)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.cityCoordinate = Coordinate(latitude: 35.02, longtitude: 139.02) // Цього не має бути
        
        guard let cityCoordinat = self.cityCoordinate else {
            locationManager.startLocation { (coordinate) in
                self.setLabelByCoordinate(coordinate: coordinate)
            }
            return
        }
        self.setLabelByCoordinate(coordinate: cityCoordinat)
    }
    fileprivate func setLabelByCoordinate(coordinate:Coordinate){
        self.networkManager.getDailyWeather(by: coordinate) { (dailyForecast) in
            self.navigationItem.title = dailyForecast.cityName
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
        }
    }
}

extension MainViewController:UISearchBarDelegate{

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        cityListTableView = UITableView(frame: .zero, style: .plain)
        cityListTableView.backgroundColor = cityListTableView.backgroundColor?.withAlphaComponent(0.6)
        self.cityListTableView.frame = CGRect.init(origin: .zero, size: self.view.frame.size)
        searchController.view.addSubview(cityListTableView)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
            self.cityList = self.locationManager.searchCity(name: searchText)
//        DispatchQueue.main.async
//        }
//        print(self.cityList)
    }
}
//extension MainViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cityList?.count ?? <#default value#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}

