//
//  Cities.swift
//  OpenWeather
//
//  Created by MineDest on 6/25/20.
//  Copyright © 2020 MineDest. All rights reserved.
//
import Foundation
import GooglePlaces

// MARK: - CityListElement
struct CityListElement {
    let name, fullName: String
    let coord: CLLocationCoordinate2D
}
typealias CityList = [CityListElement]
