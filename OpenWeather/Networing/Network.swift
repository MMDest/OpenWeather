//
//  File.swift
//  OpenWeather
//
//  Created by MineDest on 5/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

class Network {
    func network<T: Decodable>( api: String, completion: @escaping (Result <T, Error>) -> Void) {
        guard let url = URL(string: api) else {
            print(api)
            print("Error URL")
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, _, errorr) in
            guard let data = data else {
                print("Error data")
                completion(.failure(NetworkError.noJSONData))
                return
            }
            guard errorr == nil else {
                print("Error ")
                completion(.failure(NetworkError.unknown))
                return
            }
            do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                return
            } catch _ {
                print(Error.self)
                completion(.failure(NetworkError.failDecode))
                return
            }
        }.resume()
    }
}
