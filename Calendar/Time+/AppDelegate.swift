//
//  AppDelegate.swift
//  Time+
//
//  Created by LibLabs-Mac on 11/28/19.
//  Copyright © 2019 LibLabs-Mac. All rights reserved.
//

//TODO: repeat segment and gesture recognizers and labels in case there are more than six events and extend range of calendar (another 2 years?)
//TODO: Start table view at the current time
//TODO: Check for start < end time
//TODO: Sports section in iconcollectionview not showing (DONE)
//TODO: Two icons crashes the app!
//TODO: Add selection box around the bottom bar in add event controllers (DONE)
//TODO: Purge old events for memory managment

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        
        if !hasLaunched {
            let path = Bundle.main.path(forResource: "DefaultPrimaryIcons", ofType: "csv")!
            
            do{
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                
                for line in lines.dropFirst(){
                    let components = line.components(separatedBy: ",")
                    if !components[0].isEmpty{
                    
                    let name = components[1]
                    var code : UInt64 = 0
                    var color : UInt64 = 0
                    Scanner(string: components[0]).scanHexInt64(&code)
                    Scanner(string: components[2]).scanHexInt64(&color)
                    MainIconsDataBase.sharedInstance.enter(icon: Int64(code), name: name, color: Int64(color))
                    }
                    
                }
            }catch {
                fatalError("Cannot read default primary icons")
            }
            
            defaults.set(true, forKey: hasLaunchedKey)
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

