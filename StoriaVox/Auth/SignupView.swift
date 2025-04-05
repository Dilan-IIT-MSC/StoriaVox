//
//  SignupView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-12.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject internal var appSettings: AppSettings
    @EnvironmentObject private var bannerState: BannerState
    @EnvironmentObject var loadingState: LoadingState
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var viewModel: SignupViewModel = .init()
    @State private var showError: Bool = false
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ZStack {
                Color.background
                
                VStack(spacing: 16) {
                    Spacer()
                    
                    Text("Begin Your Storytelling Journey")
                        .font(.system(size: 36))
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                    
                    CustomTextField(placeholder: "Name", text: $viewModel.name, errorMessage: $viewModel.nameError)
                    
                    CustomTextField(placeholder: "Email", text: $viewModel.email, errorMessage: $viewModel.emailError)
                    
                    CustomSecureTextField(placeholder: "Password", text: $viewModel.password, errorMessage: $viewModel.passwordError)
                    
                    CustomSecureTextField(placeholder: "Confirm Password", text: $viewModel.confirmPassword, errorMessage: $viewModel.confirmPasswordError)
                
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("By clicking Sign Up, you agree to our Terms of Service and Privacy Policy.")
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                                .fontWeight(.light)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Button {
                        if viewModel.isFormValid() {
                            viewModel.signUpUser()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("Sign Up")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .cornerRadius(16)
                        .contentShape(Rectangle())
                    }
                    .padding(.top, 24)

                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        
                        Button {
                            viewModel.resetForm()
                            appSettings.mainRoute = .login
                        } label: {
                            Text("Log In")
                                .foregroundColor(.accentColor)
                                .contentShape(Rectangle())
                                .underline()
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom + 8 : 16)
                    
                }
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea()
            .banner(isPresent: $bannerState.isShowBanner)
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .forgotPassword:
                    Text("")
                case .resetPassword:
                    Text("")
                case .verifyCode:
                    VerificationCodeView(viewModel: viewModel)
                        .environmentObject(appSettings)
                        .environmentObject(bannerState)
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
