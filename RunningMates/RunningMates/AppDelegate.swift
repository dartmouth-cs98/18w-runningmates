//
//  AppDelegate.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All righ/Users/saratopic/RunningMatesBackend/18w-runningmates-backend/app/server.jsts reserved.
//

import UIKit
import OAuthSwift
import GoogleMaps
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var userEmail: String = ""

    var didSignUpWithStrava: Int = 0

     var rootUrl: String = "http://localhost:9090/"
//    var rootUrl: String = "https://running-mates.herokuapp.com/"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey("AIzaSyDAHpVdfOCgiKATZ3wtKetImiYfcz-E15c")
        GMSServices.provideAPIKey("AIzaSyDAHpVdfOCgiKATZ3wtKetImiYfcz-E15c")
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        OAuthSwift.handle(url: url)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       // SocketIOManager.sharedInstance.closeConnection()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SocketIOManager.instance.disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      //  SocketIOManager.sharedInstance.establishConnection()
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "email") != nil) {
           // userEmail = defaults.string(forKey: "email")!
            print("when app becomes active: ")
            print(userEmail)
        }
        
        SocketIOManager.instance.connect()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
