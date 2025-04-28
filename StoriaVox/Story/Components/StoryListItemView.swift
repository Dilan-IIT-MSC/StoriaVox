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
                
                if let url = story.thumbnailUrl {
                    AsyncImage(url: URL(string: url)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.backgroundColors.randomElement() ?? .gray
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(story.title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
                
                Text("By \(story.author.displayTitle)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    ForEach(Array(story.categories.enumerated()), id: \.offset) { _, category in
                        Text(category.name)
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                    
                }
                .padding(.top, 4)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.blue.opacity(0.4))
                        
                        Text(story.duration.formattedTime())
                            .font(.system(size: 12))
                            .foregroundStyle(Color.title)
                            .fontDesign(.rounded)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "ear.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.accentColor.opacity(0.4))
                        
                        Text("\(story.listenCount.abbreviated())")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.title)
                            .fontDesign(.rounded)
                    }
                    
                    
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.red.opacity(0.4))
                        
                        Text("\(story.listenCount > 0 ? story.likeCount.abbreviated(): "-")")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.title)
                            .fontDesign(.rounded)
                    }
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
    StoryListItemView(story: StoryListItem(id: 1, title: "Test story title", thumbnailUrl: "", duration: "09:00", listenCount: 34500, author: Author(id: 2, firstName: "Dilan", lastName: "Anuruddha"), likeCount: 2300, categories: [Category(id: 3, name: "Family", description: "", icon: 3, imageURL: nil)]))
}
