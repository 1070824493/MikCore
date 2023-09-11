//
//  AppDelegate.swift
//  MikCore
//
//  Created by 1070824493 on 01/27/2022.
//  Copyright (c) 2022 1070824493. All rights reserved.
//

import UIKit
@_exported import MikCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        UIFont.mik.registerCustomFonts()
        MikToast.configToastStyle()
        
        self.window = {
            let aWindow = UIWindow()

            let tabBarController = MikTabBarController()
            tabBarController.addChildViewController(Test0ViewController(), title: "Test0", normalImage: UIImage(named: "tabbar_dash_n"), selectedImage: UIImage(named: "tabbar_dash_s")!)
            tabBarController.addChildViewController(Test1ViewController(), title: "Test0", normalImage: UIImage(named: "tabbar_message_n"), selectedImage: UIImage(named: "tabbar_message_s"))

            aWindow.rootViewController = tabBarController

            aWindow.makeKeyAndVisible()
            return aWindow
        }()

        MikNavigationController.appendWhiteList([Test0ViewController.self, Test1ViewController.self])
        MikNavigationController.appendAutoHiddenTabbarWhiteList([Test0ViewController.self, Test1ViewController.self])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

