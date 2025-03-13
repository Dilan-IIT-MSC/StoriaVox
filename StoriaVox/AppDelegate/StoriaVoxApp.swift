//
//  StoriaVoxApp.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-02-15.
//

import SwiftUI

@main
struct StoriaVoxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
