//
//  File.swift
//  OpenWeather
//
//  Created by MineDest on 5/6/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation

class Network {
    func network<T: Decodable>(api:String, completion: @escaping (Result<T,Error>) -> ()){
        guard let url = URL(string: api) else {
            print("Error URL")
            return 
        }
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
                do{
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                }
                catch{
                    print(error)
                }
                return
                
            } catch _ {
                print(Error.self)
                completion(.failure(NetworkError.unknown))
                return
            }
        }.resume()
    }
}
