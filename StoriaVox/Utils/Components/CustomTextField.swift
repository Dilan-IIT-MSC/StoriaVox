//
//  CustomTextField.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-01.
//

import SwiftUI

struct CustomTextField: View, Equatable {
    @State var update: Bool = false
    var placeholder: String
    @Binding var text: String
    @Binding var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("", text: $text, prompt: Text(placeholder)
                .foregroundColor(.value))
            .font(.system(size: 14))
            .foregroundColor(Color.title)
            .padding(12)
            .cornerRadius(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(errorMessage != nil ? Color.errorBackground.opacity(0.1): .accent.opacity(0.1))
                    .stroke(errorMessage != nil ? Color.errorBackground: Color.accentColor, lineWidth: 1)
            )
            .onChange(of: text, { _, _ in
                update.toggle()
                if !text.isEmpty && errorMessage != nil {
                    errorMessage = nil
                }
            })
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
    
    static func == (lhs: CustomTextField, rhs: CustomTextField) -> Bool {
        return lhs.text == rhs.text && lhs.errorMessage == rhs.errorMessage
    }
}

#Preview {
    CustomTextField(placeholder: "placeholder", text: .constant("text"), errorMessage: .constant("error"))
}
