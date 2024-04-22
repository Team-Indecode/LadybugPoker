//
//  AppDelegate.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/6/24.
//

import UIKit
import FirebaseCore
import KakaoSDKCommon

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: "95e636931116b5fd658bd260aea7967e")

        return true
    }
}
