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
    @Binding var showError: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("", text: $text, prompt: Text(placeholder)
                .foregroundColor(.value))
            .font(.system(size: 16))
            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
            .padding(12)
            .cornerRadius(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(showError ? Color.errorBackground.opacity(0.1): .accent.opacity(0.1))
                    .stroke(showError ? Color.errorBackground: Color.accentColor, lineWidth: 1)
            )
            .onChange(of: text, { _, _ in
                update.toggle()
                if !text.isEmpty && showError {
                    showError = false
                }
            })
            .submitLabel(.done)
            .padding(.top, 8)
            .padding(.bottom, 4)
            
            if showError && text.isEmpty {
                HStack {
                    Text("This field is required")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "D66164"))
                    
                    Spacer()
                }
            }
        }
        .background(Color.background)
    }
    
    static func == (lhs: CustomTextField, rhs: CustomTextField) -> Bool {
        return lhs.text == rhs.text && lhs.showError == rhs.showError
    }
}

#Preview {
    CustomTextField(placeholder: "placeholder", text: .constant("text"), showError: .constant(false))
}
