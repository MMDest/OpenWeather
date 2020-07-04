//
//  WeatherProviderProtocol.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

protocol WeatherProviderProtocol {
    func getDailyWeather(by coordinates: Coordinate, weather: @escaping (DailyForecast) -> Void)
    func getWeeklyWeather(by coordinates: Coordinate, weather: @escaping (DailyForecast) -> Void)
}
struct DailyForecast {
    var cityName: String
    var sunrise: String
    var sunset: String
    var visibility: String
    var wind: String
    var temperature: String
    var paramets: String
    var imageUrl: String
}
struct HourlyWeather {
    var hour: String
    var main: String
    var temperature: String
    var imageUrl: String
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
