//
//  NetworkManager.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

fileprivate let apiKey = "c21900eef5ec151fd2118a950e856c37"
class OpenWeatherNetworkManager: WeatherProviderProtocol {
    var networkManager = Network()
    func getDailyWeather(by coordinates: Coordinate, weather: @escaping (DailyForecast) -> Void) {
        let units = "metric"
        networkManager.network(api: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longtitude)&units=\(units)&appid=\(apiKey)") {
            (result: Result<DailyOpenWeather, Error>) in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                weather(self.setDailyForecast(dailyOpenWeather: value))
                }
            case .failure(_):
                print("Failure")
            }
        }
    }
    enum MyError: Error {
        case network
    }
    
    func setDailyForecast(dailyOpenWeather: DailyOpenWeather) -> DailyForecast {
        let cityName = (dailyOpenWeather.name)
        var date:Date = Date(timeIntervalSince1970: TimeInterval(dailyOpenWeather.sys.sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let sunrise = "Sunrise: \(dateFormatter.string(from: date))"
        date = Date(timeIntervalSince1970: TimeInterval(dailyOpenWeather.sys.sunset))
        let sunset = "Sunset: \(dateFormatter.string(from: date))"
        var visibility = ""
        if dailyOpenWeather.visibility != nil{
        visibility = "Visibility: \(dailyOpenWeather.visibility!) m"
        }
        let wind =	"Wind: \(dailyOpenWeather.wind.deg.direction) \(dailyOpenWeather.wind.speed) m/s"
        let temperature = "\(Int(dailyOpenWeather.main.temp)) ℃"
        let parametrs = dailyOpenWeather.weather[0].main
        let imageURL = "http://openweathermap.org/img/wn/\(dailyOpenWeather.weather[0].icon)@4x.png"
        return DailyForecast(cityName: cityName,sunrise: sunrise, sunset: sunset, visibility: visibility, wind: wind, temperature: temperature, paramets: parametrs, imageUrl: imageURL)
    }
    
}
