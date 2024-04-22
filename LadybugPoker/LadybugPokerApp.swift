//
//  LadybugPokerApp.swift
//  LadybugPoker
//
//  Created by 박진서 on 4/5/24.
//

import SwiftUI

@main
struct LadybugPokerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            DefaultView()
                .environmentObject(Service.shared)
                .preferredColorScheme(.light)
        }
    }
}

