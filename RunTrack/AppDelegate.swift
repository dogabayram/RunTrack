//
//  AppDelegate.swift
//  RunTrack
//
//  Created by Doğa Bayram on 22.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit
import GoogleMobileAds

let timeFormatter = DateFormatter()
var time1 = Date()
var time2 = Date()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        GADMobileAds.configure(withApplicationID: "YOUR_ADMOB_APP_ID")

        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
//        timeFormatter.timeStyle = .medium
//        time1 = "Current time is: \(timeFormatter.string(from: Date() as Date))"
//        print(time1)
        time1 = Date()
        
        print(time1)
        print("BackGround")
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   
//        timeFormatter.timeStyle = .medium
//        time2 = "Current time is: \(timeFormatter.string(from: Date() as Date))"
//        print(time2)
        
        time2 = Date()
        
        print(time2)
        print("ForeGround")
        
        
        

        
        let newDate = time2.timeIntervalSince(time1)
        
        print(Int(newDate))
       if timer.isValid {
       counter += Int(newDate)
        }
        
//                timeFormatter.timeStyle = .medium
//               let newTime = "Current time is: \(timeFormatter.string(from: Date(timeIntervalSinceReferenceDate: newDate) ))"
//                print(newTime)
        
        
    
        
        
//        if let interval = newTime2?.timeIntervalSince(newTime1!) {
//            let hour = interval / 3600;
//            let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
//            let intervalInt = Int(interval)
//            print("\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes")
//        }
        

        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

