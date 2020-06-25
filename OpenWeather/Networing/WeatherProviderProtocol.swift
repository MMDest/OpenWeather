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
}
struct DailyForecast {
    var cityName:String
    var sunrise:String
    var sunset:String
    var visibility:String
    var wind:String
    var temperature:String
    var paramets:String
    var imageUrl:String
}
struct hourlyWeather {
    var hour:String
    var main:String
    var temperature:String
    var imageUrl:String
}
enum Direction: String {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw
}
extension Direction: CustomStringConvertible  {
    static let all: [Direction] = [.n, .nne, .ne, .ene, .e, .ese, .se, .sse, .s, .ssw, .sw, .wsw, .w, .wnw, .nw, .nnw]
    init(_ direction: Double) {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = Direction.all[index]
    }
    var description: String {
        return rawValue.uppercased()
    }
}
extension Double {
    var direction: Direction {
        return Direction(self)
    }
}
