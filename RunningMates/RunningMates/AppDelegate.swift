//
//  AppDelegate.swift
//  RunningMates
//
//  Created by Sara Topic on 30/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import OAuthSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var userEmail: String = "brian@test.com"
    var rootUrl: String = "http://localhost:9090/"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        window?.backgroundColor = UIColor.white
//
//        // Allocate memory for an instance of the 'MainViewController' class
//        let mainViewController = MyViewController()
//
//        // Set the root view controller of the app's window
//        window!.rootViewController = mainViewController
//
//        // Make the window visible
        //window!.makeKeyAndVisible()
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
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      //  SocketIOManager.sharedInstance.establishConnection()

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

