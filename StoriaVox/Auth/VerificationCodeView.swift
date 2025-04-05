//
//  VerificationCodeView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-14.
//

import SwiftUI

struct VerificationCodeView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject internal var appSettings: AppSettings
    @EnvironmentObject private var bannerState: BannerState
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SignupViewModel
    @State private var timeRemaining: Int = 60
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Verify Your Account")
                    .font(.system(size: 36))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                Text("Verification code has been sent to \(viewModel.email).")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                // Verification code field
                CustomTextField(placeholder: "Enter code", text: $viewModel.verificationCode, errorMessage: $viewModel.verificationCodeError)
                
                HStack {
                    if timeRemaining > 0 {
                        Text("Resend code in \(timeRemaining)s")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    } else {
                        Button {
                            viewModel.resendVerificationCode()
                            resetTimer()
                        } label: {
                            Text("Resend Code")
                                .foregroundColor(.accentColor)
                                .font(.system(size: 14))
                                .underline()
                        }
                    }
                }
                .padding(.top, 16)
                
                Button {
                    if viewModel.verifyCodeLength() {
                        print("codelength is correct")
                        viewModel.submitVerificationCode()
                    }
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Verify")
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
                
                Button {
                    viewModel.resetForm()
                    viewModel.path = []
                    appSettings.mainRoute = .signUp
                } label: {
                    Text("Back to sign up")
                        .foregroundColor(.gray)
                        .underline()
                }
                .padding(.bottom, safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom + 8 : 16)
            }
            .padding(.horizontal, 16)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
        .ignoresSafeArea()
        .banner(isPresent: $bannerState.isShowBanner)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private func resetTimer() {
        timeRemaining = 60
        startTimer()
    }
}
