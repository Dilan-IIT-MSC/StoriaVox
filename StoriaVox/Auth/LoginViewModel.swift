//
//  LoginViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-05.
//

import Foundation
import MSAL

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    
    internal func isFormValid() -> Bool {
        var isValid = true
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !email.isValidEmail() {
            emailError = "Invalid email format"
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Password is required"
            isValid = false
        }
        
        return isValid
    }
    
    internal func login() {
        let parameters = MSALNativeAuthSignInParameters(username: email.lowercased())
        parameters.password = password
        let msalClient = AuthenticationManager.shared.msalClient
        msalClient.signIn(parameters: parameters, delegate: self)
    }
}

// MARK: Login
extension LoginViewModel: SignInStartDelegate {
    func onSignInStartError(error: MSAL.SignInStartError) {
        print("error: \(error.localizedDescription)")
    }
    
    func onSignInCompleted(result: MSALNativeAuthUserAccountResult) {
        print(result.account)
        print(result.idToken)
    }
}
