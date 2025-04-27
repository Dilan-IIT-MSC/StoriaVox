//
//  SignupVM.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-14.
//

import SwiftUI
import MSAL

class SignupViewModel: ObservableObject {
    @Published var path: [AuthRoute] = []
    @Published var email: String = ""
    @Published var emailError: String? = nil
    @Published var password: String = ""
    @Published var passwordError: String? = nil
    @Published var confirmPassword: String = ""
    @Published var confirmPasswordError: String? = nil
    @Published var name: String = ""
    @Published var nameError: String? = nil
    @Published var verificationCode: String = ""
    @Published var verificationCodeLength: Int = 0
    @Published var verificationCodeError: String? = nil
    @Published private var newState: SignUpCodeRequiredState? = nil
    @Published var selectedCategories: Set<Int> = []
    
    internal func isFormValid() -> Bool {
        var isValid = true
        
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !email.isValidEmail() {
            emailError = "Enter valid email"
            isValid = false
        } else {
            emailError = nil
        }

        
        if password.isEmpty {
            passwordError = "Password is required"
            isValid = false
        } else {
            passwordError = nil
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password is required"
            isValid = false
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        } else {
            confirmPasswordError = nil
        }
        
        if name.isEmpty {
            nameError = "Name is required"
            isValid = false
        } else if name.count < 3 {
            nameError = "Name should be at least 3 characters long"
            isValid = false
        } else {
            nameError = nil
        }
        return isValid
    }
    
    internal func resetForm() {
        email = ""
        emailError = nil
        password = ""
        passwordError = nil
        confirmPassword = ""
        confirmPasswordError = nil
        name = ""
        nameError = nil
    }
    
    internal func showError(title:String, message: String) {
        BannerHandler.shared.showErrorBanner(title: title, message: message, isAutoHide: true)
    }
    
    internal func showSuccess(title:String, message: String) {
        BannerHandler.shared.showSuccessBanner(title: title, message: message, isAutoHide: true)
    }
    
    internal func fetchCategories() {
        CategoryService.shared.getCategories { response in
            switch response {
            case .success(let categoriesResponse):
                UserDefaultsManager.shared.savedCategories = categoriesResponse.categories.map({ $0.category})
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
}

// MARK: Signup
extension SignupViewModel: SignUpStartDelegate {
    func signUpUser() {
        let msalClient = AuthenticationManager.shared.msalClient
        do {
            let parameters = MSALNativeAuthSignUpParameters(username: email.lowercased())
            parameters.password = password
            parameters.attributes = ["displayName": name]
            msalClient.signUp(parameters: parameters, delegate: self)
        }
    }
    
    func onSignUpCodeRequired(newState: SignUpCodeRequiredState, sentTo: String, channelTargetType: MSALNativeAuthChannelType, codeLength: Int) {
        self.verificationCodeLength = codeLength
        self.newState = newState
        path.append(.verifyCode)
        showSuccess(title: "Success", message: "verification code has been sent to \(sentTo)")
    }
    func onSignUpStartError(error: MSAL.SignUpStartError) {
        self.showError(title: "SignUp Error", message: error.localizedDescription)
    }
}

// MARK: Verification Code
extension SignupViewModel: SignUpVerifyCodeDelegate {
    func onSignUpVerifyCodeError(error: MSAL.VerifyCodeError, newState: MSAL.SignUpCodeRequiredState?) {
        self.showError(title: "Verification Code Error", message: error.localizedDescription)
    }
    
    func onSignUpCompleted(newState: SignInAfterSignUpState) {
        let parameters = MSALNativeAuthSignInAfterSignUpParameters()
        newState.signIn(parameters: parameters, delegate: self)
    }
    
    internal func verifyCodeLength() -> Bool {
        if verificationCode.isEmpty {
            verificationCodeError = "Verification code is required"
            return false
        } else if verificationCode.count < verificationCodeLength {
            verificationCodeError = "Verification code length is incorrect"
            return false
        } else {
            return true
        }
    }
    
    internal func submitVerificationCode() {
        if let newState = newState {
            newState.submitCode(code: verificationCode, delegate: self)
        }
    }
}

// MARK: verification code resend
extension SignupViewModel: SignUpResendCodeDelegate {
    internal func resendVerificationCode() {
        if let newState = newState {
            newState.resendCode(delegate: self)
        }
    }
    
    func onSignUpResendCodeCodeRequired(newState: SignUpCodeRequiredState, sentTo: String, channelTargetType: MSALNativeAuthChannelType, codeLength: Int) {
        self.newState = newState
        verificationCodeLength = codeLength
        showSuccess(title: "Success", message: "Verification code resend successfully.")
    }
    
    func onSignUpResendCodeError(error: MSAL.ResendCodeError, newState: MSAL.SignUpCodeRequiredState?) {
        showError(title: "Resend Verification Code Error", message: error.localizedDescription)
    }
}

// MARK: SignIn after signup
extension SignupViewModel: SignInAfterSignUpDelegate {
    func onSignInAfterSignUpError(error: MSAL.SignInAfterSignUpError) {
        showError(title: "Sign In Error", message: error.localizedDescription)
    }
    
    func onSignInCompleted(result: MSALNativeAuthUserAccountResult) {
        DispatchQueue.main.async {
            self.path = [.completeSignUp]
        }
        showSuccess(title: "Success", message: "Account created successfully! Please complete your profile.")
    }
}
