//
//  AppDelegate.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import MediaPlayer
import HockeySDK
import AVKit
import Parse
import Bolts
import EAIntroView

private let sampleDescription1 = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
private let sampleDescription2 = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
private let sampleDescription3 = "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
private let sampleDescription4 = "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EAIntroDelegate {

    var window: UIWindow?
    var statusBarBackgroundView: UIView?
    var revealVCView: UIView!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        // Initialize Parse.
        Parse.setApplicationId("kcmNwFnHHDfanE4xbzZYzufPe5Cz74z1O4wftbej",
            clientKey: "VYQRtVcSJWUhGhjuLuy8kA7HKQ7rzbHa7Y37Work")
 
        
        #if RELEASE
            print("release mode")
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier   ("397fac4ea6ec1293bbf6b3aa1828b806")
            BITHockeyManager.sharedHockeyManager().startManager()
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
            // [Optional] Track statistics around application opens.
            PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            
            let movieURL = NSBundle.mainBundle().URLForResource("splashScreen", withExtension: "mp4")
            let moviePlayerItem = AVPlayerItem(URL: movieURL!)
            let moviePlayer = AVPlayer(playerItem: moviePlayerItem)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish", name: AVPlayerItemDidPlayToEndTimeNotification, object: moviePlayerItem)
            let playerController = AVPlayerViewController()
            playerController.player = moviePlayer
            playerController.showsPlaybackControls = false
            window?.rootViewController = playerController
            moviePlayer.play()
        #else
            print("debug mode")
            moviePlayBackDidFinish()
        #endif
     
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc
    private func moviePlayBackDidFinish() {
        #if RELEASE
            let loginNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginVCNavigationController") as! UINavigationController
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            loginVC.dismissBlock = {
                let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                self.window?.rootViewController = revealVC
                print("dismiss block executing from appdelegate")
                self.setUpNavBarAndStatusBarImages()
            }
            loginNavCtrl.viewControllers = [loginVC]
            window?.rootViewController = loginNavCtrl
        #else
            //NO LOGIN FOR DEBUG JUST FOR NOW - comment it out to test Login screen
            let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = revealVC
            
            //Walkthrough testing
            let walkthroughVC = UIViewController()
            walkthroughVC.view.frame = window!.frame
            walkthroughVC.title = "Welcome"
            let navigationCtrl = UINavigationController(rootViewController: walkthroughVC)
            navigationCtrl.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            
            //This below code gets rid of bottom 1px border from navigation bar, so we can make it look like a bottom border never exists
            //couldn't get the border to disappear for some reason. it stayed white.
//            navigationCtrl.navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
//            navigationCtrl.navigationBar.shadowImage = UIImage()
//            navigationCtrl.navigationBar.clipsToBounds = true
//            navigationCtrl.navigationBar.translucent = false
            
            let page1 = EAIntroPage()
            page1.title = "Welcome"
            page1.titlePositionY = walkthroughVC.view.frame.size.height - 30
            page1.desc = sampleDescription1
            //setting position on these work weirdly. Higher the number, Higher it goes up toward top of screen. Lower the number, more it sticks to bottom of screen
            page1.descPositionY = walkthroughVC.view.frame.size.height - 30 - 48
            let walkthroughImageView1 = UIImageView(image: UIImage(named: "walkthroughImage1"))
            page1.titleIconView = walkthroughImageView1
            page1.titleIconPositionY = walkthroughVC.view.frame.size.height - walkthroughImageView1.frame.size.height
            
            let page2 = EAIntroPage()
            page2.title = "This is page 2";
            page2.desc = sampleDescription2;
            
            let page3 = EAIntroPage()
            page3.title = "This is page 3";
            page3.desc = sampleDescription3;
            
            let introView = EAIntroView(frame: walkthroughVC.view.frame, andPages: [page1,page2,page3])
            //if you want to the navigation bar way
            //let introView = EAIntroView(frame: walkthroughVC.view.frame, andPages: [page1,page2,page3,page4])
            introView.delegate = self
            introView.pageControlY = walkthroughVC.view.frame.size.height - 30 - 48 - 64;
            introView.bgImage = UIImage(named: "bg_gradient")
            introView.showInView(walkthroughVC.view, animateDuration: 0.3)
            self.window?.rootViewController = walkthroughVC
            
        #endif
            setUpNavBarAndStatusBarImages()
    }
    
    //MARK: EAIntroViewDelegate
    func introDidFinish(introView: EAIntroView!) {
        print("intro walkthrough finished")
    }
    
    func setUpNavBarAndStatusBarImages() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation_bar"), forBarMetrics: UIBarMetrics.Default)
        statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackgroundView!.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        window?.rootViewController?.view.addSubview(statusBarBackgroundView!)
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
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

