//
//  AppSettings.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//
import SwiftUI
import MSAL

class AppSettings: ObservableObject {
    @Published var path = NavigationPath()
    @Published var route: Route = .unspecified
    @Published var nativeAuth: MSALNativeAuthPublicClientApplication?
    
    init() {
        do {
            self.nativeAuth = try MSALNativeAuthPublicClientApplication(
                clientId: "f33cf369-7f6a-4c45-b005-e739e3ecb4ea",
                tenantSubdomain: "storiavoxapp",
                challengeTypes: [.OOB, .password]
            )
            
            print("Initialized Native Auth successfully.")
        } catch {
            print("Unable to initialize MSAL: \(error)")
        }
    }
}
