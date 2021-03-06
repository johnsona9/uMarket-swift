//
//  AppDelegate.swift
//  uSell
//
//  Created by Adam Johnson on 8/6/15.
//
//

import UIKit
import Parse
import Bolts
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   // var pushNotificationController : PushNotificationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("ulMdyGO6N6gcQJKf9lENE8pOopKLh85EnW8MKT0K",
            clientKey: "fDl4Uz9sM3D9VzC5eFrW9PLK5vdSbUW9JU0Gucec")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            let settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()

        } else {
            print("not connected to internet")
        }
        
        UINavigationBar.appearance().barTintColor = GlobalConstants.Colors.navigatorBarBackgroundColor
        UINavigationBar.appearance().tintColor = GlobalConstants.Colors.navigatorBarTextColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : GlobalConstants.Colors.navigatorBarTextColor]
        
        return true
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

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let reachability = Reachability.reachabilityForInternetConnection()
        if (reachability.isReachable()) {
            let currentInstallation : PFInstallation = PFInstallation.currentInstallation()
            currentInstallation.setDeviceTokenFromData(deviceToken)
            currentInstallation.saveInBackground()
        } else {
            print("not connected to internet")
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("failed to register: \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }

}

