//
//  LoginView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject internal var appSettings: AppSettings
    @EnvironmentObject private var bannerState: BannerState
    @EnvironmentObject var loadingState: LoadingState
    @StateObject var viewModel: LoginViewModel = .init()
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 16) {
                Spacer()
                
                Text("Welcome back to StoriaVox!")
                    .font(.system(size: 36))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                
                CustomTextField(placeholder: "Email", text: $viewModel.email, errorMessage: $viewModel.emailError)
                
                VStack(spacing: 4) {
                    CustomSecureTextField(placeholder: "Password", text: $viewModel.password, errorMessage: $viewModel.passwordError)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Forgot Password?")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                    }
                }
                
                Button {
                    if viewModel.isFormValid() {
                        viewModel.login()
                    }
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Sign In")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                }
                .padding(.top, 24)

                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                    
                    Button {
                        appSettings.mainRoute = .signUp
                    } label: {
                        Text("Sign Up")
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
        .onAppear {
            let user = AuthenticationManager.shared.msalClient.getNativeAuthUserAccount()
            print("logged in user \(user?.account.username)")
        }
    }
}

#Preview {
    LoginView()
}
