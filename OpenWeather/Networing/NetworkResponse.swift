//
//  NetworkResponse.swift
//  OpenWeather
//
//  Created by MineDest on 5/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
