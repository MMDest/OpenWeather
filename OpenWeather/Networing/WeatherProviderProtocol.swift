//
//  WeatherProviderProtocol.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

protocol WeatherProviderProtocol {
    func getForecast(by coordinates: Coordinate, weather: @escaping (WeatherForecast) -> Void)
}
struct WeatherForecast {
//    var cityName: String
    var sunrise: String
    var sunset: String
    var visibility: String
    var wind: String
    var temperature: String
    var paramets: String
    var imageUrl: String
    var dailyWeather: [DailyWeatherForecast]
    var weekWeather: [WeeklyWeatherForecast]
}

struct DailyWeatherForecast {
    var hourTemp: String
    var hourImage: String
    var hour: String
}
struct WeeklyWeatherForecast {
    var weekDay: String
    var weekImage: String
    var minTemperature: Int
    var maxTemperature: Int
}

enum Direction: String, CodingKey, CaseIterable {
    case nDirection = "n"
    case nneDirection = "nne"
    case neDirection = "ne"
    case eneDirection = "ene"
    case eDirection = "e"
    case eseDirection = "ese"
    case seDirection = "se"
    case sseDirection = "sse"
    case sDirection = "s"
    case sswDirection = "ssw"
    case swDirection = "sw"
    case wswDirection = "wsw"
    case wDirection = "w"
    case wnwDirection = "wnw"
    case nwDirection = "nw"
    case nnwDirection = "nnw"
}
extension Direction: CustomStringConvertible {
    var description: String {
        return rawValue.uppercased()
    }
    init(_ direction: Double) {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = Direction.allCases[index]
    }
}
extension Double {
    var direction: Direction {
        return Direction(self)
    }
}
