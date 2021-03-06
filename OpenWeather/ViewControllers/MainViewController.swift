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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingController = storyboard.instantiateViewController(
            withIdentifier: "SettingViewController") as? SettingViewController
        settingController?.delegat = self
        self.navigationController?.pushViewController(settingController ?? SettingViewController(), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        tableView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.5)
        stackListView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.5)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: height).isActive = true
        self.navigationController?.navigationBar.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.5)
            locationManager.startLocation { (coordinate) in
                self.cityCoordinate = coordinate
                self.setLabelByCoordinate(coordinate: coordinate,
                                          city: "")
                self.locationManager.stopUpdateLocation()
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let cordinate = cityCoordinate else {
            return
        }
        self.setLabelByCoordinate(coordinate: cordinate, city: "")
//        DispatchQueue.main.async {
//            self.navigationItem.title = self.locationManager.currentCity(coordinate: self.cityCoordinate!)
//        }
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
    }

    func updateByCoordinate(coordinate: Coordinate, city: String) {
        self.activityIndicator.isHidden = false
            self.cityCoordinate = coordinate
            self.cityName = city
            self.setLabelByCoordinate(coordinate: coordinate, city: city)
//        self.tabBarController?.selectedIndex = 0
    }
}
// MARK: TableView setting
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
// MARK: Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = weekWeathers?.count else {
            return 0
        }
        return count
    }
// MARK: Cell For row
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
// MARK: Heigh for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
// MARK: CollectionViewSetting
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: Number of row in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = dayWeathers?.count else {
            return 0
        }
        return count
    }
    // MARK: Cell for row
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
