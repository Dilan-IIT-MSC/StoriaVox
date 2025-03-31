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
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                categoryImage()
                .offset(x: 72)
                
                categoryImage()
                
                categoryImage()
                .offset(x: -72)
                
                Spacer()
            }
            .frame(width: 176, height: 96)
            
            HStack(alignment: .center) {
                ZStack {
                    Circle()
                        .fill(.lightGreen50)
                        .stroke(.border, lineWidth: 1)
                        .frame(width: 30, height: 30, alignment: .center)
                        .shadow(radius: 1)
                    
                    category.icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24, alignment: .center)
                    
                }

                
                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.title)
                    
                    Text("\(Int.random(in: 0...1000)) Stories")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(.secondValue)
                }

                
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding(16)
        .frame(width: 176)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.backgroundColors.randomElement() ?? .whiteBackground)
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
        )
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    func categoryImage() -> some View {
        AsyncImage(url: URL(string: "https://picsum.photos/230/128")) { image in
            image.resizable()
        } placeholder: {
            Color.backgroundColors.randomElement() ?? .gray
        }
        .frame(width: 96, height: 96)
        .background(Color.backgroundColors.randomElement())
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 2)
        )
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    CategoryTileView(category: .init(name: "sample", icon: .init(.love)))
}
