//
//  LoginView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Welcome back to StoriaVox!")
                    .font(.system(size: 36))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                
                TextField("", text: $emailAddress, prompt: Text("Email")
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
                
                SecureField("", text: $password, prompt: Text("Password")
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
                        Text("Forgot Password?")
                            .foregroundColor(.gray)
                            .fontWeight(.regular)
                    }
                }
                .padding(.top, 8)
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Sign In")
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
                    
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    Button {
                        
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
    }
}

#Preview {
    LoginView()
}
