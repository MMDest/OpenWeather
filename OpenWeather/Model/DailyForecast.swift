//
//  DailyForecast.swift
//  OpenWeather
//
//  Created by MineDest on 7/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

// MARK: - DailyForecast
struct DailyForecast: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}
// MARK: - Current
struct Current: Codable {
    let date: Int
    let sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds: Int
    let visibility: Int?
    let windSpeed: Double
    let windDeg: Double
    let weather: [DailyForecastWeather]

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Weather
struct DailyForecastWeather: Codable {
    let weatherId: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Daily
struct Daily: Codable {
    let date: Int
    let sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [DailyForecastWeather]
    let clouds: Int
    let rain, uvi: Double?

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, rain, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Hourly
struct Hourly: Codable {
    let date: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [DailyForecastWeather]
    let rain: Rain?
    let snow: Snow?

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain, snow
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
// MARK: - Rain
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}
