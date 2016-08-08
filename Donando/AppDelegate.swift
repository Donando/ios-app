//
//  AppDelegate.swift
//  Donando
//
//  Created by Halil Gursoy on 25/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let mainAPIUrl = "https://backend.donando.eu"
    let fallbackAPIUrl = "https://fathomless-ridge-60760.herokuapp.com/"
    
    var apiReady = false
    
    let webClient = WebClient()
    
    static let APIReadyNotification = "APIReadyNotification"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let isReachable = webClient.checkUrlIsReachable(mainAPIUrl+"/demands")
        isReachable.onSuccess(callback: useMainAPI)
        isReachable.onFailure(callback: useFallbackAPI)
        
        window?.tintColor = UIColor.mainTintColor()
        let barAppearace = UIBarButtonItem.appearance()
        barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics:UIBarMetrics.Default)
        
        setupFabric()
        
        return true
    }
    
    func useMainAPI(result: AnyObject?) {
        Endpoints.baseURI = mainAPIUrl
        apiIsReady()
    }
    
    func useFallbackAPI(error: DonandoError) {
        Endpoints.baseURI = fallbackAPIUrl
        apiIsReady()
    }
    
    func apiIsReady() {
        apiReady = true
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.APIReadyNotification, object: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func setupFabric() {
        #if DEBUG
            Fabric.sharedSDK().debug = true
        #endif
        
        Fabric.with([Crashlytics.self])
    }
}

