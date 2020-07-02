//
//  LocationManager.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

struct Coordinate {
    var latitude: Double
    var longtitude: Double
}

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    var didUpdateLocation:((Coordinate)->Void)?
    var fetcher: GMSAutocompleteFetcher?
    var placesClient: GMSPlacesClient?
    var cityList:CityList?
    let locationManager = CLLocationManager()
    
    func startLocation(_ didUpdateLocation: @escaping (Coordinate)->Void){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.didUpdateLocation = didUpdateLocation
    }
    
    func searchCity(name: String) -> CityList {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
//        DispatchQueue.main.async {
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
            self.fetcher = GMSAutocompleteFetcher()
            self.fetcher?.autocompleteFilter = filter
            self.fetcher?.delegate = self
            self.fetcher?.provide(token)
            self.fetcher?.sourceTextHasChanged(name)
//        }
        return cityList ?? CityList()
    }
    
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        didUpdateLocation?(Coordinate(latitude: locValue.latitude , longtitude: locValue.longitude))
        
    }
}
extension LocationManager: GMSAutocompleteFetcherDelegate {
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    placesClient = GMSPlacesClient()
    cityList = CityList()
    for prediction in predictions {
    guard let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) |
        UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.name.rawValue))  else {
        return
        }
        placesClient?.fetchPlace(fromPlaceID: prediction.placeID, placeFields:fields, sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
          if let place = place {
            guard let city = place.formattedAddress?.capitalized else {
                return
            }
            
            self.cityList?.append(CityListElement(name: place.name ?? "", fullName: city, coord: place.coordinate))
          }
        })
        
    }
//    resultText?.text = resultsStr as String
  }

  func didFailAutocompleteWithError(_ error: Error) {
//    resultText?.text = error.localizedDescription
  }
}
