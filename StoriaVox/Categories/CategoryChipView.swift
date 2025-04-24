//
//  CategoryChipView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import SwiftUI

struct CategoryChipView: View {
    @State private var isSelected: Bool = false
    @Binding var selectedCategories: Set<Int>
    var category: Category
    
    var body: some View {
        Button {
            if isSelected {
                selectedCategories.remove(category.id)
                withAnimation {
                    isSelected.toggle()
                }
            } else {
                if selectedCategories.count < 3 && !selectedCategories.contains(category.id){
                    selectedCategories.insert(category.id)
                    withAnimation {
                        isSelected.toggle()
                    }
                }
            }
            
        } label: {
            HStack {
                CategoryIconView(icon: category.getIcon())
                
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
    CategoryChipView(
        selectedCategories: .constant([]),
        category: .init(id: 222, name: "Love", description: "love description", icon: 3))
}
