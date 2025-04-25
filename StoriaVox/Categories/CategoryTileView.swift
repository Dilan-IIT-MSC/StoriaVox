//
//  CategoryTileView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-29.
//

import SwiftUI

struct CategoryTileView: View {
    var category: Category
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                categoryImage(url: category.imageURL ?? "")
            }
            .frame(height: 150)
            
            HStack(alignment: .center) {
                CategoryIconView(icon: category.getIcon())

                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.title)
                        .fontDesign(.rounded)
                    
                    Text("\(Int.random(in: 0...1000)) Stories")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(.secondValue)
                }

                
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
        }
        .padding(.bottom, 16)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.backgroundColors.randomElement() ?? .whiteBackground)
                .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 3)
        )
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    func categoryImage(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
        } placeholder: {
            Color.backgroundColors.randomElement() ?? .gray
        }
        .frame(height: 150)
        .background(Color.backgroundColors.randomElement())
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    CategoryTileView(category: .init(id: 22, name: "Family", description: "family description", icon: 0, imageURL: nil))
}
