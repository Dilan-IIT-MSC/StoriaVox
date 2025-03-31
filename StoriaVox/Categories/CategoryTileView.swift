//
//  CategoryTileView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-29.
//

import SwiftUI

struct CategoryTileView: View {
    var title: String
    
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
            
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.title)
                    .padding(.top, 16)
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                Image(systemName: "music.note.house")
                    .resizable()
                    .foregroundStyle(.secondValue)
                    .frame(width: 16, height: 16)
                
                Text("\(Int.random(in: 0...1000)) Stories")
                    .font(.system(size: 13, weight: .light))
                    .foregroundStyle(.secondValue)
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(16)
        .frame(width: 176)
        .background(Color.backgroundColors.randomElement())
        .clipShape(.rect(cornerRadius: 16))
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
    CategoryTileView(title: "Category name")
}
