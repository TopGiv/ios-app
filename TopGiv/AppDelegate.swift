//
//  AppDelegate.swift
//  TopGiv
//
//  Created by Michael Feigenson on 5/31/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import Stripe
import CoreData
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var loginMode = 0
    var userID = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // [START firebase_configure]
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        // [END firebase_configure]
        
        // [START setup_gidsignin]
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance().delegate = self
        // [END setup_gidsignin]
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        Stripe.setDefaultPublishableKey("pk_test_g8WKfRukyzUdNWy0lJ7cFna5")

        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            if loginMode == 1 {
                
                return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
                
            }
            else if loginMode == 2 {
                
                return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
                
            }
            else {
                
                return false
                
            }
            
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            
            print(error.localizedDescription)
            
            return
            
        }
            
        else {
            
            // Perform any operations on signed in user here.
            
            let userId = user.userID                  // For client-side use only!
            
            let idToken = user.authentication.idToken // Safe to send to the server
            
            let fullName = user.profile.name
            
            let givenName = user.profile.givenName
            
            let familyName = user.profile.familyName
            
            let email = user.profile.email
            
            print(userId!, idToken!, fullName!, givenName!, familyName!, email!)
            
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
        }
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            
            let url: URL? = userActivity.webpageURL
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let navigationController: UINavigationController? = (window?.rootViewController as? UINavigationController)
            
            if (url?.pathComponents.contains("login"))! {
                navigationController?.pushViewController(storyBoard.instantiateViewController(withIdentifier: "ProfileInfoViewController"), animated: true)
                
            }
            
        }
        
        return true
        
    }

    func shouldAutorotate() -> Bool {
        return false
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

