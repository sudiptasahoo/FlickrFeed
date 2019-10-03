//
//  AppDelegate.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 28/09/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        AppRouter().configureRootViewController(inWindow: window)
        self.window = window
        return true
    }
}

