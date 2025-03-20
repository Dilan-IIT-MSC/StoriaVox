//
//  SignupView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-12.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject internal var appSettings: AppSettings
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var viewModel: SignupVM = .init()
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Begin Your Storytelling Journey")
                    .font(.system(size: 36))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                TextField("", text: $viewModel.name, prompt: Text("Name")
                    .foregroundColor(.gray))
                .textFieldStyle(.plain)
                .textContentType(.name)
                .foregroundStyle(.black)
                .frame(height: 50)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.accent.opacity(0.1))
                        .stroke(Color.accentColor, lineWidth: 0.5)
                )
                
                TextField("", text: $viewModel.username, prompt: Text("Email")
                    .foregroundColor(.gray))
                .textFieldStyle(.plain)
                .textContentType(.emailAddress)
                .foregroundStyle(.black)
                .frame(height: 50)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.accent.opacity(0.1))
                        .stroke(Color.accentColor, lineWidth: 0.5)
                )
                .padding(.top, 24)
                
                SecureField("", text: $viewModel.password, prompt: Text("Password")
                    .foregroundColor(.gray))
                .frame(height: 50)
                .padding(.horizontal, 16)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.accent.opacity(0.1))
                        .stroke(Color.accentColor, lineWidth: 0.5)
                )
                .padding(.top, 24)
                
                SecureField("", text: $viewModel.confirmPassword, prompt: Text("Confirm Password")
                    .foregroundColor(.gray))
                .frame(height: 50)
                .padding(.horizontal, 16)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.accent.opacity(0.1))
                        .stroke(Color.accentColor, lineWidth: 0.5)
                )
                .padding(.top, 24)
                
                
                
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
                    viewModel.signUpUser(nativeAuth: appSettings.nativeAuth)
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Sign Up")
                            .font(.system(size: 24, weight: .medium))
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
    }
}

#Preview {
    SignupView()
}
