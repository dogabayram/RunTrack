//
//  RunVC.swift
//  RunTrack
//
//  Created by Doğa Bayram on 22.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var startButton: UIButton!
    
    
    var weight : Double?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkLocationAuthStatus()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        //let newExercise = Exercises(context: context)
        //newExercise.name = name
        //
        //        do {
        //        try context.save()
        //            print("Saved")
        //        } catch {
        //            print("Error")
        //        }
        //
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //startButton.isEnabled = false
        
        
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        if weight != nil {
            if weight! < 250.0 {
                performSegue(withIdentifier: "currentVC", sender: self)
            } else {
                // alert
                alertMessage(message: "Set weight less than 250")
            }
            
        } else {
            alertMessage(message: "Set your weight before starting")
        }
        
    }
    
    
    func alertMessage(message : String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
        // getLastRun()
    }
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }

    
    func centerMapOnUserLocation() {
        
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
    }

 
    @IBAction func centerPressed(_ sender: UIButton) {
        
        centerMapOnUserLocation()
        
    }
    
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
        if textField.text != nil {
            weightLabel.text = "\(textField.text!) kg"
            weight = Double(textField.text!)
           // startButton.isEnabled = true
        } else {
            //alertMessage(message: "Set your weight")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? CurrentRunVC
        destVC?.weight = weight ?? 0.0
    }
    
    

}

extension BeginRunVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            
        }
    }
    

 
}



