//
//  ResetPasswordView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-01.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordReset: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Create New Password")
                    .font(.system(size: 36))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                if !isPasswordReset {
                    Text("Your new password must be different from previously used passwords")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                    
                    SecureField("", text: $newPassword, prompt: Text("New Password")
                        .foregroundColor(.gray))
                    .padding(12)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent.opacity(0.1))
                            .stroke(Color.accentColor, lineWidth: 0.5)
                    )
                    
                    SecureField("", text: $confirmPassword, prompt: Text("Confirm Password")
                        .foregroundColor(.gray))
                    .padding(12)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent.opacity(0.1))
                            .stroke(Color.accentColor, lineWidth: 0.5)
                    )
                    .padding(.top, 24)
                    
                    Button {
                        isPasswordReset = true
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("Reset Password")
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
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 20)
                        
                        Text("Password Reset Successful!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        Text("Your password has been changed successfully.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                    
                    Button {
                        
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
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ResetPasswordView()
}
