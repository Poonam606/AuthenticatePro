//
//  AppDelegate.swift
//  AuthenticatePro
//
//  Created by Love Verma on 20/05/18.
//  Copyright © 2018 Kavita. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import LinkedinSwift
import GoogleSignIn
var deviceTokenGet = String()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "16686680101-l1gv5dlv0k85jllb5orglluub56434pp.apps.googleusercontent.com"
       // GIDSignIn.sharedInstance().delegate = self
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
    application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        if UserDefaults.standard.bool(forKey: DefaultsIdentifier.isLogin) {
            
             let mainMenu = mainStoryBoard.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
            let nav = UINavigationController(rootViewController:mainMenu)
            if let userRole = UserDefaults.standard.value(forKey:DefaultsIdentifier.Role) as? String {
                userType = userRole
            }
            self.window?.rootViewController = nav
        }

        // Override point for customization after application launch.
        return true
    }
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        deviceTokenGet = deviceToken.hexString
        print(deviceTokenGet)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError: Error)
    {
        print("error")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       if LinkedinSwiftHelper.shouldHandle(url) {
           
            return LinkedinSwiftHelper.application( application, open: url, sourceApplication:[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
        }
      else if let scheme = url.scheme {
            if scheme.hasPrefix("google".lowercased())
            {
          return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
               //   return GPPURLHandler.handle(url, sourceApplication: sourceApplication, annotation: annotation)
            }
        }
          /*  if GPPURLHandler.handle(url, sourceApplication: sourceApplication, annotation: annotation)
        {
            return GPPURLHandler.handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }*/
        else
        {
              /*  return GPPURLHandler.handle(url, sourceApplication: sourceApplication, annotation: annotation)*/
         return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
       return true
        

    }
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("givenName", userId,fullName,givenName)
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("will dispatch4")
        print("In didDisconnectWith: \(error.localizedDescription)")
       // self.completionBlock?(nil)
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

