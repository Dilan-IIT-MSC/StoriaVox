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
    @StateObject private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            switch appSettings.route {
            case .unspecified: SignupView().environmentObject(appSettings)
            case .login: LoginView()
            case .signUp: SignupView().environmentObject(appSettings)
                    
            default: BaseView()
            }
        }
    }
}
