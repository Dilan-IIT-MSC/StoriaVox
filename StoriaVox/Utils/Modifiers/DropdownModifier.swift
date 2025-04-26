//
//  DropdownModifier.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

struct Dropdownmodifier: ViewModifier {
    @Binding var showError: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(showError ? Color(hex: "f9f5f5"): .white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .inset(by: 0.5)
                    .stroke(showError ? (Color(hex: "D66164") ?? .clear): Color.border, lineWidth: 1)
            )
    }
}
