//
//  AppDelegate.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appId : String! = "638ca751-f202-4a30-9af9-570ad31eedee"
    // I put the sandbox secret key
    let secretKey : String! = "df7f983b-7309-4417-b2fd-fc47a03352b8"
    let redirectScheme : String! = "caro2-ios://"
    
    var mojio : MojioClient?
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var controller = window?.rootViewController as UITabBarController
        controller.selectedIndex = 1
        
        self.mojio = MojioClient.client() as? MojioClient
        
        if let mojio = self.mojio {
            mojio.initWithAppId(self.appId,
                andSecretKey: self.secretKey, andRedirectUrlScheme: self.redirectScheme)
            
            /*

            NSDictionary *queryOptions = @{@"limit" : @1, @"offset" : @0, @"sortBy" : @"LastContactTime", @"desc" : @"true"};
            [self.client getEntityWithPath:@"Vehicles" withQueryOptions:queryOptions success:^(id responseObject) {
            // executed when the data is successfully fetched
            }failure: ^{
            // executed if there was an error in trying to retrieve data
            }];
            
            */
            var queryOptions = [
                "limit": 1,
                "offset": 0,
                "sortBy": "LastContactTime",
                "desc": "true"
            ]
            mojio.getEntityWithPath("Vehicles", withQueryOptions: queryOptions, success: {
                (obj: AnyObject!) in
                println(obj)
            }, failure: {
                (err: NSError!) in
                println(err)
            })
            
            mojio.loginWithCompletionBlock {
                println("Logged in!")
            }
            
            println("Mojio is initialized", mojio)
        } else {
            println("Mojio is None")
        }
        return true
    }

    func handleOpenURL(url: NSURL) -> ObjCBool {
        self.mojio?.handleOpenURL(url)
        println("handleOpenURL(\(url))")
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


}

