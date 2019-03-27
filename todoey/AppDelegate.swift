//
//  AppDelegate.swift
//  todoey
//
//  Created by jesus jimenez on 3/9/19.
//  Copyright © 2019 edgysoft. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let _  = try? Realm()
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }
    
}

