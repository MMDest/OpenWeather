//
//  NetworkManager.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

private let apiKey = "c21900eef5ec151fd2118a950e856c37"
class OpenWeatherNetworkManager: WeatherProviderProtocol {

    var networkManager = Network()
    var locationManager = LocationManager()
    var distanceUnits: Double {
        switch UserDefaults.standard.string(forKey: "Distance") {
        case "km":
            return 0.001
        case "mi":
            return 0.00062137
        default:
            return 0
        }
    }
    func speedUnits(speed: Double) -> String {
        switch UserDefaults.standard.string(forKey: "Distance") {
        case "km":
            return "\(round(speed*100)/100) m/s"
        case "mi":
            return "\(round((speed * 2.236936)*100)/100) mph"
        default:
            return ""
        }
    }
    func temperatureUnits(celsium: Double) -> Double {
        switch UserDefaults.standard.string(forKey: "Temperature") {
        case "˚C":
            return celsium
        case "˚F":
            return (celsium * 1.8) + 32
        case "˚K":
            return celsium + 273.15
        default:
            return 0
        }
    }

    func getForecast(by coordinates: Coordinate, weather: @escaping (WeatherForecast) -> Void) {
        guard let units = UserDefaults.standard.string(forKey: "units") else {
            return
        }
        networkManager.network(api:
            """
            https://api.openweathermap.org/data/2.5/onecall?\
            lat=\(coordinates.latitude)\
            &lon=\(coordinates.longtitude)\
            &units=\(units)\
            &appid=\(apiKey)
            """
        ) { (result: Result<DailyForecast, Error>) in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                weather(self.setForecast(weatherForecast: value))
                }
            case .failure:
                print("Failure")
            }
        }
    }

    func setForecast(weatherForecast: DailyForecast) -> WeatherForecast {// swiftlint:disable:this function_body_length
        var date = Date(timeIntervalSince1970: TimeInterval(weatherForecast.current.sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let sunrise = "Sunrise: \(dateFormatter.string(from: date))"
        date = Date(timeIntervalSince1970: TimeInterval(weatherForecast.current.sunset))
        let sunset = "Sunset: \(dateFormatter.string(from: date))"
        var visibility = ""
        if weatherForecast.current.visibility != nil {
            let distanceUnit = UserDefaults.standard.string(forKey: "Distance") ?? ""
            let distance = round((weatherForecast.current.visibility!) * distanceUnits * 100) / 100
            visibility = "Visibility: \(distance) \(distanceUnit)"
        }
        let speedUnit = speedUnits(speed: weatherForecast.current.windSpeed)
        let wind =	"""
        Wind: \(weatherForecast.current.windDeg.direction) \
        \(speedUnit)
        """
        let tempUnits = UserDefaults.standard.string(forKey: "Temperature")
        let temperature = "\(Int(temperatureUnits(celsium: weatherForecast.current.temp))) \(tempUnits ?? "")"
        let parametrs = weatherForecast.current.weather[0].main
        let imageURL = "http://openweathermap.org/img/wn/\(weatherForecast.current.weather[0].icon)@4x.png"
        var weekWeathers = [WeeklyWeatherForecast]()
        for weather in weatherForecast.daily {
            let image = "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@4x.png"
            dateFormatter.dateFormat = "EEEE"
            date = Date(timeIntervalSince1970: TimeInterval(weather.date))
            let weekWeather = WeeklyWeatherForecast(weekDay: dateFormatter.string(from: date),
                                                    weekImage: image,
                                                    minTemperature: Int(temperatureUnits(celsium: weather.temp.min)),
                                                    maxTemperature: Int(temperatureUnits(celsium: weather.temp.max)))
            weekWeathers.append(weekWeather)
        }
        var dailyWethers = [DailyWeatherForecast]()
        var countWeatherForecast = 0
        for weather in weatherForecast.hourly {
            dateFormatter.dateFormat = "HH"
            date = Date(timeIntervalSince1970: TimeInterval(weather.date))
            let image = "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@4x.png"
            var dailyWeather = DailyWeatherForecast(hourTemp: "\(Int(temperatureUnits(celsium: weather.temp)))˚",
                                                   hourImage: image,
                                                   hour: dateFormatter.string(from: date))
//            if dailyWeather.hour == "00" {
//                dailyWeather.hour = "Tomorrow"
//            }
            if weather.date == weatherForecast.hourly.first?.date {
                            dailyWeather.hour = "Now"
            }
            dailyWethers.append(dailyWeather)
            if countWeatherForecast == 23 {
                break
            }
            countWeatherForecast += 1
        }
        return WeatherForecast(
                             sunrise: sunrise, sunset: sunset,
                             visibility: visibility, wind: wind,
                             temperature: temperature, paramets: parametrs,
                             imageUrl: imageURL, dailyWeather: dailyWethers,
                             weekWeather: weekWeathers)
    }
}
