//
//  AppDelegate.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
        let navCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootNavController") as! UINavigationController
        window?.rootViewController! = navCtrl
        
        //Navbar and Statusbar background image setup - storyboard doesn't do this wtf
        
        if (iOS7 || iOS8) {
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
            statusBarView.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
            window?.rootViewController?.view .addSubview(statusBarView)
            

        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation_bar"), forBarMetrics: UIBarMetrics.Default)
        
        
        
        
        #if RELEASE
            let movieURL = NSBundle.mainBundle().URLForResource("splashScreen", withExtension: "mp4")
    
            let myMoviePlayer = MPMoviePlayerViewController(contentURL: movieURL)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish", name: MPMoviePlayerPlaybackDidFinishNotification, object: myMoviePlayer.moviePlayer)
    
            myMoviePlayer.moviePlayer.controlStyle = MPMovieControlStyle.None
            myMoviePlayer.moviePlayer.backgroundView.addSubview(UIImageView(image: UIImage(named: "launchScreenLayer4")))
            myMoviePlayer.moviePlayer.scalingMode = MPMovieScalingMode.Fill
            window?.rootViewController! = myMoviePlayer
            myMoviePlayer.moviePlayer.setFullscreen(true, animated: false)
            myMoviePlayer.moviePlayer.play()
        #endif

        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    @objc
    private func moviePlayBackDidFinish() {
        let navCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootNavController") as! UINavigationController
        window?.rootViewController! = navCtrl
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
