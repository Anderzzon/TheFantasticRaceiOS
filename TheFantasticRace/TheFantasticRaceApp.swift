//
//  TheFantasticRaceApp.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-02-06.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Setting up Firebase")
    return true
  }
}

@main
struct TheFantasticRaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var userInfo = UserInfo()
    
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userInfo)
        }
    }
}
