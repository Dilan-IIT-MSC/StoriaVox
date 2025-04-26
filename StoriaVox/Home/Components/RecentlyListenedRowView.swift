//
//  RecentlyListenedView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-29.
//

import SwiftUI

struct RecentlyListenedRowView: View {
    let story: RecentStory
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: "https://picsum.photos/64/64")) { image in
                image.resizable()
            } placeholder: {
                Color.backgroundColors.randomElement() ?? .gray
            }
            .frame(width: 64, height: 64)
            .background(Color.backgroundColors.randomElement())
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: .gray.opacity(0.5), radius: 1)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(story.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.title)
                
                Text("by \(story.author.displayTitle)")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(.title)
                
                Spacer()
                
                if !(story.isRecommended ?? false) {
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                            .resizable()
                            .foregroundStyle(.gray)
                            .frame(width: 14, height: 14)
                        
                        Text("\(story.duration.formattedTime())")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            Spacer()
            
            ZStack(alignment: .center) {
                Image(systemName: "play.fill")
                    .foregroundStyle(.accent)
                    .frame(width: 30, height: 24, alignment: .center)
                
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 36, height: 36, alignment: .center)
                    .foregroundStyle(.accent)
            }
            .frame(width: 40, height: 40, alignment: .center)
            
        }
        .frame(height: 64)
    }
}
