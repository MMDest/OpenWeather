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

    func getForecast(by coordinates: Coordinate, weather: @escaping (WeatherForecast) -> Void) {
//        let units = "metric"
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

    func setForecast(weatherForecast: DailyForecast) -> WeatherForecast {
        var date = Date(timeIntervalSince1970: TimeInterval(weatherForecast.current.sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let sunrise = "Sunrise: \(dateFormatter.string(from: date))"
        date = Date(timeIntervalSince1970: TimeInterval(weatherForecast.current.sunset))
        let sunset = "Sunset: \(dateFormatter.string(from: date))"
        var visibility = ""
        if weatherForecast.current.visibility != nil {
        visibility = "Visibility: \(weatherForecast.current.visibility!) m"
        }
        let wind =	"Wind: \(weatherForecast.current.windDeg.direction) \(weatherForecast.current.windSpeed) m/s"
        let temperature = "\(Int(weatherForecast.current.temp)) ℃"
        let parametrs = weatherForecast.current.weather[0].main
        let imageURL = "http://openweathermap.org/img/wn/\(weatherForecast.current.weather[0].icon)@4x.png"
        var weekWeathers = [WeeklyWeatherForecast]()
        for weather in weatherForecast.daily {
            let image = "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@4x.png"
            dateFormatter.dateFormat = "EEEE"
            date = Date(timeIntervalSince1970: TimeInterval(weather.date))
            var weekWeather = WeeklyWeatherForecast(weekDay: dateFormatter.string(from: date),
                                                    weekImage: image, minTemperature: Int(weather.temp.min),
                                                    maxTemperature: Int(weather.temp.max))
            if weather.date == weatherForecast.daily.first?.date {
                weekWeather.weekDay = "Today"
            }
            weekWeathers.append(weekWeather)
        }
        var dailyWethers = [DailyWeatherForecast]()
        for weather in weatherForecast.hourly {
            dateFormatter.dateFormat = "HH"
            date = Date(timeIntervalSince1970: TimeInterval(weather.date))
            let image = "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@4x.png"
            let dailyWeather = DailyWeatherForecast(hourTemp: "\(Int(weather.temp))˚",
                                                   hourImage: image, hour: dateFormatter.string(from: date))
            dailyWethers.append(dailyWeather)
        }
        return WeatherForecast(
                             sunrise: sunrise, sunset: sunset,
                             visibility: visibility, wind: wind,
                             temperature: temperature, paramets: parametrs,
                             imageUrl: imageURL, dailyWeather: dailyWethers,
                             weekWeather: weekWeathers)
    }
}
