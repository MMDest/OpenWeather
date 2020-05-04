//
//  LocationManager.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import Foundation
import CoreLocation
class LocationManager: NSObject, CLLocationManagerDelegate{
    
    struct Coordinate {
        var latitude: Double
        var longtitude: Double
    }
    var didUpdateLocation:((Coordinate)->Void)?
    
    let locationManager = CLLocationManager()
    func startLocation(_ didUpdateLocation: @escaping (Coordinate)->Void){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("Start updating")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.didUpdateLocation = didUpdateLocation
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        didUpdateLocation?(Coordinate(latitude: locValue.latitude , longtitude: locValue.longitude))
        
    }
    
    
}
