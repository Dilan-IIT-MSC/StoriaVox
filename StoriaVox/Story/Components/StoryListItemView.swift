//
//  StoryListItemView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-26.
//

import SwiftUI

struct StoryListItemView: View {
    let story: StoryListItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .cornerRadius(8)
                
                AsyncImage(url: URL(string: "https://picsum.photos/230/128")) { image in
                    image.resizable()
                } placeholder: {
                    Color.backgroundColors.randomElement() ?? .gray
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("The Great Adventure of Thor")
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
                
                Text("By Jane Smith")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    Text("Fantasy")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    
                    Text("Fantasy")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    
                    Text("Fantasy")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
                .padding(.top, 4)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        
                        Text("12 min")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "ear.fill")
                            .font(.system(size: 12))
                        
                        Text("3.2k")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .modifier(CardView())
    }
}

#Preview {
    StoryListItemView(story: StoryListItem(id: 1, title: "Test story title", thumbnailUrl: "", created: Date(), duration: 09.34, listenCount: 34500, author: Author(id: 2, firstName: "Dilan", lastName: "Anuruddha"), likeCount: 2300, categories: []))
}
