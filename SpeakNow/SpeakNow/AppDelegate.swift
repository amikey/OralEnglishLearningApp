//
//  AppDelegate.swift
//  SpeakNow
//
//  Created by 称一称 on 16/4/15.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        LeanCloud.initialize(applicationID: "iCnaTRwvat0REUTViiX3KBvu-gzGzoHsz", applicationKey: "NTBgO118rRnaipNn0Q9GnuBh")
        AVOSCloud.setApplicationId("iCnaTRwvat0REUTViiX3KBvu-gzGzoHsz", clientKey: "NTBgO118rRnaipNn0Q9GnuBh")
        AVOSCloud.initialize()
        if inf.username == ""{
            window=UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.makeKeyAndVisible()
            let VC = getVC("LoginNav")
            window?.rootViewController = VC
        }else{
        }


        IFlySetting.setLogFile(.LVL_ALL)

        IFlySetting.showLogcat(true)
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as String

        IFlySetting.setLogFilePath(cachePath)

        let initString = "appid=57a698b5"

        IFlySpeechUtility.createUtility(initString)




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
        // Saves changes in the application's managed object context before the application terminates.
    }


    func changeRootVC(vc:UIViewController){
        if(((self.window?.rootViewController) == nil)){
            self.window?.rootViewController = vc
            return
        }

        let snapshot = self.window!.snapshotViewAfterScreenUpdates(true) 
        vc.view.addSubview(snapshot)
        self.window?.rootViewController=vc

        UIView.animateWithDuration(0.5, animations: {
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                _ in
                snapshot.removeFromSuperview()
        })

    }

}

