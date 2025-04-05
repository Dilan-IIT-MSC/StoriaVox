//
//  CustomSecureTextField.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-05.
//

import SwiftUI

struct CustomSecureTextField: View, Equatable {
    var placeholder: String
    @Binding var text: String
    @Binding var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            SecureField("", text: $text, prompt: Text(placeholder)
                .foregroundColor(.gray))
            .font(.system(size: 14))
            .foregroundColor(Color.title)
            .padding(12)
            .textInputAutocapitalization(.never)
            .keyboardType(.asciiCapable)
            .autocorrectionDisabled(true)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(errorMessage != nil ? Color.errorBackground.opacity(0.1): .accent.opacity(0.1))
                    .stroke(errorMessage != nil ? Color.errorBackground: Color.accentColor, lineWidth: 1)
            )
            .submitLabel(.done)
            .padding(.top, 8)
            .padding(.bottom, 4)
            
            if let error = errorMessage {
                HStack {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "D66164"))
                    
                    Spacer()
                }
            }
        }
        .background(Color.background)
        
    }
    
    static func == (lhs: CustomSecureTextField, rhs: CustomSecureTextField) -> Bool {
        return lhs.text == rhs.text && lhs.errorMessage == rhs.errorMessage
    }
}
