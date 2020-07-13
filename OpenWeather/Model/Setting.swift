//
//  Settins.swift
//  OpenWeather
//
//  Created by MineDest on 7/9/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

enum SettingType: Int, CaseIterable, CustomStringConvertible {
    case general
    case units
    case more
    var description: String {
        switch self {
        case .more:
            return "More"
        case .units:
            return "Units"
        case .general:
            return "General"
        }
    }
}
enum UnitsOptions: Int, CaseIterable, CustomStringConvertible {
    case distance
    case temperature
    var description: String {
        switch self {
        case .distance:
            return "Distance"
        case .temperature:
            return "Temperature"
        }
    }
    var units: [String] {
        switch self {
        case .distance:
            return ["km", "mi"]
        case .temperature:
            return ["˚C", "˚F", "˚K"]
        }
    }
}
enum MoreOptions: Int, CaseIterable, CustomStringConvertible {
    case aboutUs
    var description: String {
        switch self {
        case .aboutUs:
            return "About us"
        }
    }
}
enum GeneralOptions: Int, CaseIterable, CustomStringConvertible {
    case language
    var description: String {
        switch self {
        case .language:
            return "Language"
        }
    }
    var languages: [String] {
        switch self {
        case .language:
            return ["English", "Ukrainian"]
        }
    }
}
