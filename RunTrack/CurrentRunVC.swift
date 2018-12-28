//
//  RunDetailViewController.swift
//  RunTrack
//
//  Created by Doğa Bayram on 22.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit
import MapKit

var timer = Timer()
var counter = 0

class CurrentRunVC: LocationVC  {

    @IBOutlet var swipeBGImageView: UIImageView!
    @IBOutlet var sliderImageView: UIImageView!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var paceLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var calorieLabel: UILabel!
    
    var startLocation :CLLocation!
    var lastLocation : CLLocation!
    
    
    
    
    var runDistance = 0.0
    var km = 0
    var pace = 0
    var calorie = 0.0
    var weight = 0.0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
        counter = 0
        
        

        
    }
    
    
    @IBAction func pauseButton(_ sender: UIButton) {
        
        if timer.isValid {
        pauseRun()
        } else {
            startRun()
            pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    
    func startRun() {
        
        manager?.startUpdatingLocation()
        startTimer()
        
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
       
        performSegue(withIdentifier: "endRun", sender: self)
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as? LogViewController
        destVC?.calorie = String(format: "%.2f", arguments: [calorie])
        destVC?.speed = "\(calculatePace(time: counter, km: runDistance.metersToKm(places: 2))) /km"
        destVC?.distance = "\(runDistance.metersToKm(places: 2)) /km"
        destVC?.time = counter.formatTimeDurationToString()
        
        
        UserDefaults.standard.set(String(format: "%.2f", arguments: [calorie]), forKey: "calorie")
        UserDefaults.standard.set("\(calculatePace(time: counter, km: runDistance.metersToKm(places: 2))) /km", forKey: "speed")
        UserDefaults.standard.set("\(runDistance.metersToKm(places: 2)) /km", forKey: "distance")
        UserDefaults.standard.set(counter.formatTimeDurationToString(), forKey: "time")
        
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
        
        
    }

    func startTimer() {
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
    }
    @objc func updateCounter() {
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace(time second : Int , km : Double) -> String {
        
        if km > 0 {
        pace = Int((Double(second)/km))
        return pace.formatTimeDurationToString()
        } else {
            
            return "00:00"
            
        }
    }
    
    
    func calculateCalorie(time second : Int , km : Double) -> String {
        
        
        let newCalorieKm = (weight * 2.205) * 0.30

        let calorieKm = (newCalorieKm * 1000.0) / 1600.0
        
        calorie += (km * calorieKm) / 1000

        return String(format: "%.2f", arguments: [calorie])
        
        
    }
    
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer){
        
        let minAdjust : CGFloat = 85
        let maxAdjust : CGFloat = 127
        
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= swipeBGImageView.center.x + maxAdjust {
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    endRun()
                    //dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
        
                
                
                
                
            }else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }
}

extension CurrentRunVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if startLocation == nil{
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)

            distanceLabel.text = "\(runDistance.metersToKm(places: 2)) / km"
   
            if counter > 0 && runDistance > 0 {
                paceLabel.text = "\(calculatePace(time: counter, km: runDistance.metersToKm(places: 2))) / km"
                calorieLabel.text = calculateCalorie(time: counter, km: lastLocation.distance(from: location))
            }
       
        }
    
        lastLocation = locations.last
    }
    
}

extension Double {
    
    func metersToKm(places : Int) -> Double {
        let divisor = pow(10.0, Double(places))
       return ((self / 1000.0) * divisor).rounded() / divisor
    }
    
}



extension Int {
    
    func formatTimeDurationToString() -> String {
        
     let durationHours = self / 3600
     let durationMinutes = (self % 3600) / 60
     let durationSeconds = (self % 3600) % 60
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes,durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours,durationMinutes,durationSeconds)
            }
        }
        
    }
}



//extension NSDate {
//
//    func getDateString() -> String {
//
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: self as Date)
//        let day = calendar.component(.day, from: self as Date)
//        let year = calendar.component(.year, from: self as Date)
//
//
//        return "\(day)/\(month)/\(year)"
//
//
//   }
//
//
//}
