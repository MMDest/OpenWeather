//
//  LocationManager.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces

struct Coordinate {
    var latitude: Double
    var longtitude: Double
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    var didUpdateLocation: ((Coordinate) -> Void)?
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    func startLocation(_ didUpdateLocation: @escaping (Coordinate) -> Void) {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.didUpdateLocation = didUpdateLocation
    }

    func currentCity(coordinate: Coordinate) -> String {
        var city = ""
//        DispatchQueue.main.async {
        let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longtitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, _) -> Void in
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                // Location name
                if let locationName = placeMark.locality {
                    city = locationName
                }
            })
//        }
        return city
    }
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locationManager.stopUpdatingLocation()
        let locValue: CLLocationCoordinate2D = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0,
                                                                                                      longitude: 0)
        didUpdateLocation?(Coordinate(latitude: locValue.latitude, longtitude: locValue.longitude))
    }
}
