//
//  LogViewController.swift
//  RunTrack
//
//  Created by Doğa Bayram on 26.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LogViewController: UIViewController , GADInterstitialDelegate {
    @IBOutlet var calorieLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    
    var interstitial: GADInterstitial!

    
    
    var calorie = "0.0"
    var speed = "0:00 /km"
    var distance = "0.0 /km"
    var time = "00:00:00"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()

        calorieLabel.text = UserDefaults.standard.string(forKey: "calorie") ?? calorie
        speedLabel.text = UserDefaults.standard.string(forKey: "speed") ?? speed
        distanceLabel.text = UserDefaults.standard.string(forKey: "distance") ?? distance
        timeLabel.text = UserDefaults.standard.string(forKey: "time") ?? time
        
        
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    

    @IBAction func restartButton(_ sender: UIButton) {
        var counterKey =  UserDefaults.standard.integer(forKey: "adsCounter")
        
        print(counterKey)
        
        if counterKey >= 3 {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            }
            
            
            interstitial = createAndLoadInterstitial()
            UserDefaults.standard.set(0, forKey: "adsCounter")
        } else {
            
            counterKey += 1
            UserDefaults.standard.set(counterKey, forKey: "adsCounter")


        }
        
        performSegue(withIdentifier: "runVC", sender: self)
        
    }
    
}
