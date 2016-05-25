//
//  AppDelegate.swift
//  SimpleTableView
//
//  Created by Andrei Puni on 25/12/14.
//  Copyright (c) 2014 Andrei Puni. All rights reserved.
//

import UIKit
import AVFoundation
import AVFoundation.AVAudioSession
import MediaPlayer


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    
    var testPlayer: AVAudioPlayer? = nil
    var textView: UITextView? = nil
    var clearField: UIView? = nil
    var session: AVAudioSession? = nil
    var volumeView: MPVolumeView? = nil
    var maxVolume: CGFloat = 0.99999
    var minVolume: CGFloat = 0.00001
    var initialVolume: CGFloat = 0.5


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // register to get volume input by playing an audio sample
        testPlayer = loadSound("silence")
        testPlayer?.numberOfLoops = -1
        testPlayer?.play()
        
        listenVolumeButton()
        
        // disable hud (this replaces the default hud with a custom 0x0 view
        volumeView = MPVolumeView(frame: CGRectMake(-1000,-1000,0,0) )
        UIApplication.sharedApplication().windows.first?.addSubview(volumeView!)
        
        // set initial volume (when we intercept volume change events, we'll reset the volume level)
        session = AVAudioSession.sharedInstance()
        //initialVolume = CGFloat(session!.outputVolume)

        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let nc = (self.window?.rootViewController?.navigationController)! as UINavigationController
        
        application.beginReceivingRemoteControlEvents()
        
        self.becomeFirstResponder()
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
    
    
    
    // MARK:
    // MARK: intercept volume controls
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func loadSound(filename: NSString) -> AVAudioPlayer? {
        let url = NSBundle.mainBundle().URLForResource(filename as String, withExtension: "caf")
        if let player = try? AVAudioPlayer(contentsOfURL: url!) {
            player.prepareToPlay()
            return player
        }
        return nil
    }
    
    func listenVolumeButton(){
        let audioSession = AVAudioSession.sharedInstance()
        session = audioSession
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self, forKeyPath: "outputVolume",
                                     options: NSKeyValueObservingOptions.New, context: nil)
        } catch _ {
        }
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        let rc = event!.subtype
        print("rc.rawValue: \(rc.rawValue)")
        if (rc.rawValue == 103
            
            // for bragi dash
            || rc.rawValue == 101
            || rc.rawValue == 100
            ){
            //toggleRecognition()
            var topController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UINavigationController
            let lastVC = topController.viewControllers[topController.viewControllers.count-1]
            let anyMirror = Mirror(reflecting: lastVC)
            if (anyMirror.subjectType==TalkViewController.self){
                print("this is a talkie")
                let tvc = lastVC as! TalkViewController
                tvc.select()
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "outputVolume"{
            let delta = initialVolume - ( change!["new"] as! CGFloat )
            if (delta != 0){
                let num:NSNumber = NSNumber(float: Float(initialVolume))
                
                // reset volume
                MPMusicPlayerController.applicationMusicPlayer().setValue(num, forKeyPath: "volume")
                
                // get the viewcontroller in the stack
                var topController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UINavigationController
                let lastVC = topController.viewControllers[topController.viewControllers.count-1]
                let anyMirror = Mirror(reflecting: lastVC)
                if (anyMirror.subjectType==TalkViewController.self){
                    print("this is a talkie")
                    let tvc = lastVC as! TalkViewController
                    
                    if ( delta > 0 ) {
                        print("down")
                        //selectNext()
                        tvc.down()
                        
                    } else if ( delta < 0 ) {
                        print("up")
                        //selectPrev()
                        tvc.up()
                    }

                } else {
                    return
                }
            }
            // reset volume level?
        }
    }
    



}

