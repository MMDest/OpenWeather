//
//  LocationManager.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate {
    var latitude: Double
    var longtitude: Double
}

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    var didUpdateLocation:((Coordinate)->Void)?
    
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
    
    
    
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        didUpdateLocation?(Coordinate(latitude: locValue.latitude , longtitude: locValue.longitude))
        
    }
}
