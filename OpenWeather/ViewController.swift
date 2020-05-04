//
//  ViewController.swift
//  OpenWeather
//
//  Created by MineDest on 5/4/20.
//  Copyright © 2020 MineDest. All rights reserved.
//

import UIKit

import MapKit

class ViewController: UIViewController {
    var locationManager = LocationManager()
    @IBOutlet weak var sunriseLabel: UILabel!
    
    override func viewDidLoad() {
      super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.startLocation { (coordinate) in
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
}


