//
//  SignupVM.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-14.
//

import SwiftUI
import MSAL

class SignupVM: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
}

extension SignupVM: SignUpStartDelegate {
    func signUpUser(nativeAuth: MSALNativeAuthPublicClientApplication?) {
        guard let nativeAuth = nativeAuth else { return }
        
        do {
            let parameters = MSALNativeAuthSignUpParameters(username: username)
            parameters.password = password
            parameters.attributes = ["displayName": name]
            nativeAuth.signUp(parameters: parameters, delegate: self)
        }
    }
    
    func onSignUpCodeRequired(newState: SignUpCodeRequiredState, sentTo: String, channelTargetType: MSALNativeAuthChannelType, codeLength: Int) {
        print("Verification code sent to \(sentTo)")
        
    }
    func onSignUpStartError(error: MSAL.SignUpStartError) {
        print("xxx \(error.localizedDescription)")
    }
}
