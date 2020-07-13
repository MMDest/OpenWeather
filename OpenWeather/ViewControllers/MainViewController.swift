//
//  ViewController.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit
import GooglePlaces

class MainViewController: UIViewController {
    var locationManager = LocationManager()
    var networkManager: WeatherProviderProtocol = OpenWeatherNetworkManager()
    var cityCoordinate: Coordinate?
    var cityName: String?
    var searchController = SearchViewController()
    var weekWeathers: [WeeklyWeatherForecast]?
    var dayWeathers: [DailyWeatherForecast]?
    var settingController = SettingViewController()
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var parametrsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackListView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func showSearchBarAction(_ sender: Any) {
        searchController = SearchViewController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .systemIndigo
        searchController.delegat = self
        self.present(searchController, animated: true, completion: nil)
    }
    @IBAction func showSettingViewController(_ sender: Any) {
        settingController = SettingViewController()
        settingController.delegat = self
        self.navigationController?.pushViewController(settingController, animated: true)
//        self.performSegue(withIdentifier: "showSettingVC", sender: nil)
//        self.present(settingController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.5)
        stackListView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.5)
            locationManager.startLocation { (coordinate) in
                self.cityCoordinate = coordinate
                self.setLabelByCoordinate(coordinate: coordinate,
                                          city: "")
            }
    }
    // MARK: Set label by coordinate
    private func setLabelByCoordinate(coordinate: Coordinate, city: String) {

        self.networkManager.getForecast(by: coordinate) { (dailyForecast) in
            self.sunriseLabel.text = dailyForecast.sunrise
            self.sunsetLabel.text = dailyForecast.sunset
            self.visibilityLabel.text = dailyForecast.visibility
            self.temperatureLabel.text = dailyForecast.temperature
            self.windLabel.text = dailyForecast.wind
            self.parametrsLabel.text = dailyForecast.paramets
            guard let url = URL(string: dailyForecast.imageUrl) else {
            return
            }
            self.weekWeathers = dailyForecast.weekWeather
            self.dayWeathers = dailyForecast.dailyWeather
            self.collectionView.reloadData()
            self.tableView.reloadData()
            self.activityIndicator.isHidden = true
            self.weatherIconImage.load(url: url)
            guard city == "" else {
                self.navigationItem.title = city
                return
            }

        }
    }
}
// MARK: Delagate
extension MainViewController: BackToMainVCDelegat {
    func uppdate() {
        self.setLabelByCoordinate(coordinate: cityCoordinate!, city: cityName ?? "")
        print("HOLA")
    }
    func updateByCoordinate(coordinate: Coordinate, city: String) {
        self.activityIndicator.isHidden = true
            self.cityCoordinate = coordinate
            self.cityName = city
            self.setLabelByCoordinate(coordinate: coordinate, city: city)
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = weekWeathers?.count else {
            return 0
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dailyWeather",
                                                       for: indexPath) as? DailyWeatherTableViewCell else {
            return DailyWeatherTableViewCell()
        }
        guard let weekWeather = weekWeathers?[indexPath.row] else {
            return DailyWeatherTableViewCell()
        }
        cell.maxTemperature.text = "\(weekWeather.maxTemperature)˚"
        cell.minTemperature.text = "\(weekWeather.minTemperature)˚"
        cell.weekDay.text = weekWeather.weekDay
        guard let url = URL(string: weekWeather.weekImage) else {
        return cell
        }
        cell.weatherImageView.load(url: url)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = dayWeathers?.count else {
            return 0
        }
        return count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyWeather",
                                                            for: indexPath) as? HourlyWeatherCollectionViewCell else {
            return HourlyWeatherCollectionViewCell()
        }
        guard let dailyWeather = dayWeathers?[indexPath.row] else {
            return HourlyWeatherCollectionViewCell()
        }
        cell.hourLabel.text = dailyWeather.hour
        cell.temperatureLabel.text = dailyWeather.hourTemp
        guard let url = URL(string: dailyWeather.hourImage) else {
        return cell
        }
        cell.weatherImageView.load(url: url)
        return cell
    }
}
