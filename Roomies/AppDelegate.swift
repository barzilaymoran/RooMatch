//
//  AppDelegate.swift
//  Roomies
//
//  Created by Studio on 23/12/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
      
        let navFont = UIFont(name: "CentabelBook", size:17)!
        let tabFont = UIFont(name: "CentabelBook", size:14)!
        let navAttr = [NSAttributedString.Key.font : navFont]
        let tabAttr = [NSAttributedString.Key.font : tabFont]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(navAttr, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(tabAttr, for: .normal)
        UINavigationBar.appearance().titleTextAttributes = navAttr
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

