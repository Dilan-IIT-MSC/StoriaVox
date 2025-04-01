//
//  VerificationCodeView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-14.
//

import SwiftUI

struct VerificationCodeView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var verificationCode: String = ""
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
                
                Text("Enter the verification code sent to your email")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                // Verification code field
                TextField("", text: $verificationCode, prompt: Text("Enter code")
                    .foregroundColor(.gray))
                .textFieldStyle(.plain)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.black)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.accent.opacity(0.1))
                        .stroke(Color.accentColor, lineWidth: 0.5)
                )
                
                HStack {
                    if timeRemaining > 0 {
                        Text("Resend code in \(timeRemaining)s")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    } else {
                        Button {
                            // Resend code action
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
                    // Verification action
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
                    // Navigate back to login
                } label: {
                    Text("Back to Login")
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

#Preview {
    VerificationCodeView()
}
