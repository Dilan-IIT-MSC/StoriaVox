//
//  AuthenticationManager.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-03.
//

import Foundation
import SwiftUI
import MSAL

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: MSALNativeAuthUserAccountResult?
    @Published var errorMessage: String?
    @Published var isAttemptingAutoLogin = false
    var msalClient: MSALNativeAuthPublicClientApplication
    
    static let shared = AuthenticationManager()
    
    private init() {
        do {
            self.msalClient = try MSALNativeAuthPublicClientApplication(
                clientId: "f33cf369-7f6a-4c45-b005-e739e3ecb4ea",
                tenantSubdomain: "storiavoxapp",
                challengeTypes: [.OOB, .password]
            )
            MSALGlobalConfig.loggerConfig.setLogCallback { (level, message, containsPII) in
                if !containsPII {
                    print("[MSAL] \(message ?? "")")
                }
            }
            MSALGlobalConfig.loggerConfig.logLevel = .verbose
            if let user = msalClient.getNativeAuthUserAccount() {
                UserDefaultsManager.shared.loggedInUserEmail = user.account.username
                isAuthenticated = true
            }
        } catch {
            fatalError("Failed to initialize MSAL client: \(error)")
        }
    }
}
