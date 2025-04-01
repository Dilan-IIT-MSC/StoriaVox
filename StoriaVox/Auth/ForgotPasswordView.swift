//
//  ForgotPasswordView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-14.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    @State private var emailAddress: String = ""
    @State private var isSent: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Reset Your Password")
                    .font(.system(size: 36))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                if !isSent {
                    Text("Enter your email address to receive a password reset link")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                    
                    // Email field
                    TextField("", text: $emailAddress, prompt: Text("Email")
                        .foregroundColor(.gray))
                    .textFieldStyle(.plain)
                    .textContentType(.emailAddress)
                    .foregroundStyle(.black)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent.opacity(0.1))
                            .stroke(Color.accentColor, lineWidth: 0.5)
                    )
                    
                    // Send reset link button
                    Button {
                        // Send reset link action
                        isSent = true
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("Send Reset Link")
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
                } else {
                    // Success message
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 20)
                        
                        Text("Reset Link Sent!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        Text("We've sent instructions to reset your password to \(emailAddress)")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Text("Please check your email inbox and spam folder")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                    
                    // Return to login button
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("Return to Login")
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
                }
                
                Spacer()
                
                if !isSent {
                    Button {
                        dismiss()
                    } label: {
                        Text("Back to Login")
                            .foregroundColor(.gray)
                            .underline()
                    }
                    .padding(.bottom, safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom + 8 : 16)
                }
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ForgotPasswordView()
}
