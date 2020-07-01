//
//  Cities.swift
//  OpenWeather
//
//  Created by MineDest on 6/25/20.
//  Copyright © 2020 MineDest. All rights reserved.
//
import Foundation

// MARK: - CityListElement
struct CityListElement: Codable {
    let id: Int
    let name, state, country: String
    let coord: Coord
}
typealias CityList = [CityListElement]
