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
    @Published var path: [Route] = []
    @Published var isAuthenticated = false
    @Published var user: MSALNativeAuthUserAccountResult?
    @Published var errorMessage: String?
    @Published var isAttemptingAutoLogin = false
    private var msalClient: MSALNativeAuthPublicClientApplication
    private let isAuthenticatedKey = "com.codewithdilan.storiavox.isAuthenticated"
    private let usernameKey = "com.codewithdilan.storiavox.username"
    
    static let shared = AuthenticationManager()
    
    private init() {
        do {
            self.msalClient = try MSALNativeAuthPublicClientApplication(
                clientId: "f33cf369-7f6a-4c45-b005-e739e3ecb4ea",
                tenantSubdomain: "storiavoxapp",
                challengeTypes: [.OOB, .password]
            )
        } catch {
            fatalError("Failed to initialize MSAL client: \(error)")
        }
    }
    
    func signIn(username: String, password: String) {
        let parameters = MSALNativeAuthSignInParameters(username: username)
        parameters.password = password
        msalClient.signIn(parameters: parameters, delegate: self)
    }
    
    func signUp(username: String, password: String) {
        let parameters = MSALNativeAuthSignUpParameters(username: username)
        parameters.password = password
        msalClient.signUp(parameters: parameters, delegate: self)
    }
    
    func signOut() {
        
    }
}

// MARK: SignIn delegate
extension AuthenticationManager: SignInStartDelegate {
    func onSignInStartError(error: MSAL.SignInStartError) {
        BannerHandler.shared.showErrorBanner(title: "Sign In Error.", message: error.errorDescription ?? "", isAutoHide: true)
    }
    
    func onSignInCompleted(result: MSALNativeAuthUserAccountResult) {
        BannerHandler.shared.showSuccessBanner(title: "Success.", message: "signed in successfully.", isAutoHide: true)
    }
}

// MARK: Signup delegate
extension AuthenticationManager: SignUpStartDelegate {
    func onSignUpStartError(error: MSAL.SignUpStartError) {
        BannerHandler.shared.showErrorBanner(title: "Sign Up Error.", message: error.errorDescription ?? "", isAutoHide: true)
    }
    
    func onSignUpCompleted(result: MSALNativeAuthUserAccountResult) {
        
    }
    
    func onSignInCodeRequired(newState: SignInCodeRequiredState, sentTo: String, channelTargetType: MSALNativeAuthChannelType, codeLength: Int) {
        print("Verification code sent to \(sentTo) - length: \(codeLength)")
    }
}
