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
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var appSettings = AppSettings()
    @StateObject private var bannerState = BannerState()
    @StateObject private var loadingState = LoadingState()
    
    var body: some Scene {
        WindowGroup {
            switch appSettings.mainRoute {
            case .login:
                LoginView()
                    .withAppEnvironment(appSettings: appSettings, bannerState: bannerState, loadingState: loadingState)
            case .signUp:
                SignupView()
                    .withAppEnvironment(appSettings: appSettings, bannerState: bannerState, loadingState: loadingState)
            case .home:
                MainTabView()
                    .withAppEnvironment(appSettings: appSettings, bannerState: bannerState, loadingState: loadingState)
            default:
                MainTabView()
                    .withAppEnvironment(
                        appSettings: appSettings,
                        bannerState: bannerState,
                        loadingState: loadingState)
                    .onAppear {
                        appSettings.mainRoute = .home
                    }
//                if authManager.isAuthenticated {
//                    MainTabView()
//                        .withAppEnvironment(
//                            appSettings: appSettings,
//                            bannerState: bannerState,
//                            loadingState: loadingState)
//                        .onAppear {
//                            appSettings.mainRoute = .home
//                        }
//                } else if authManager.isAttemptingAutoLogin {
//                    Text("Attempting auto login...")
//                } else {
//                    if UserDefaultsManager.shared.isOnboardTourDone {
//                        LoginView()
//                            .withAppEnvironment(appSettings: appSettings, bannerState: bannerState, loadingState: loadingState)
//                            .onAppear {
//                                appSettings.mainRoute = .login
//                            }
//                    } else {
//                        OnboardView()
//                            .withAppEnvironment(appSettings: appSettings, bannerState: bannerState, loadingState: loadingState)
//                    }
//                }
            }
        }
    }
}
