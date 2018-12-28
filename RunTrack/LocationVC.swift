//
//  LocationVC.swift
//  RunTrack
//
//  Created by Doğa Bayram on 22.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController , MKMapViewDelegate {

    var manager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness


    }
    
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }
    
}


