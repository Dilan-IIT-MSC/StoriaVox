//
//  AppDelegate.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-10.
//

import UIKit
import MSAL

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        do {
            let nativeAuth = try MSALNativeAuthPublicClientApplication(
                clientId: "4fa61d8d-4f2e-4a39-b3cb-e2ebaf7c0427",
                tenantSubdomain: "storiavox.onmicrosoft.com",
                challengeTypes: [.OOB, .password]
            )

            print("Initialized Native Auth successfully.")
         } catch {
            print("Unable to initialize MSAL \(error)")
         }
        return true
    }
}
