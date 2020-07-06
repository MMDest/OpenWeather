// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dailyOpenWeather = try? newJSONDecoder().decode(DailyOpenWeather.self, from: jsonData)

import Foundation

// MARK: - DailyOpenWeather
struct DailyOpenWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Double?
    let wind: Wind
    let clouds: Clouds
    let date: Int
    let sys: Sys
    let timezone, cityId: Int
    let name: String
    let cod: Int
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case date = "dt"
        case sys
        case timezone
        case cityId = "id"
        case name
        case cod
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike: Double
    let tempMin, tempMax, pressure, humidity: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let sysId: Int
    let type: Int
    let country: String
    let sunrise, sunset: Int
    enum CodingKeys: String, CodingKey {
        case sysId = "id"
        case type
        case country
        case sunrise
        case sunset
    }
}

// MARK: - Weather
struct Weather: Codable {
    let weatherId: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Double
}
