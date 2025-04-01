//
//  CategoryChipView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import SwiftUI

struct CategoryChipView: View {
    @State private var isSelected: Bool = false
    var category: Category
    
    var body: some View {
        Button {
            withAnimation {
                isSelected.toggle()
            }
        } label: {
            HStack {
                CategoryIconView(icon: category.icon)
                
                Text(category.name)
                    .font(.system(size: 16))
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondValue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor.opacity(0.3) : Color.clear)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor.opacity(0.7) :Color.gray.opacity(0.7), lineWidth: 1)
            )
        }

    }
}

#Preview {
    CategoryChipView(category: .init(id: 222, name: "Sample Category", icon: .init(.love)))
}
