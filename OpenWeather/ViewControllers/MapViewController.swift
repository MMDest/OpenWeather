//
//  MapViewController.swift
//  OpenWeather
//
//  Created by MineDest on 7/14/20.
//  Copyright © 2020 MineDest. All rights reserved.
//
import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var getWeatherButton: UIButton!

    var delegat: BackToMainVCDelegat?
    var locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherButton.layer.cornerRadius = 0.5 * getWeatherButton.bounds.size.height
        locationManager.startLocation { (coordinate) in
            self.mapView.camera = GMSCameraPosition.camera(
                withTarget: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                   longitude: coordinate.longtitude),
                zoom: 15)
            print(coordinate)
            self.locationManager.stopUpdateLocation()
        }
    }
    @IBAction func getWeatherAction(_ sender: Any) {
        let point = CGPoint(x: markerImageView.center.x, y: (mapView.frame.height/2))
        let coordinate = self.mapView.projection.coordinate(for: point)
        let navigationVC = tabBarController?.viewControllers![0] as? UINavigationController
        let mainVC = navigationVC?.topViewController as? MainViewController
        mainVC?.cityCoordinate = Coordinate(latitude: coordinate.latitude, longtitude: coordinate.longitude)
        self.tabBarController?.selectedIndex = 0
    }
}
