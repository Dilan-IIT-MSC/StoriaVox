//
//  StoryTileView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-29.
//

import SwiftUI

struct StoryTileView: View {
    let story: StoryListItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let url = story.thumbnailUrl {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable()
                } placeholder: {
                    Color.backgroundColors.randomElement() ?? .gray
                }
                .frame(width: 230, height: 128)
                .background(Color.backgroundColors.randomElement())
            }
            
            Divider()
            
            HStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading) {
                    Text(story.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.title)
                    
                    Text("by \(story.author.displayTitle)")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(Color.value)
                }
                
                Spacer()
                
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "ear.badge.waveform")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 16, height: 18)
                    
                    Text("\(story.listenCount.abbreviated())")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.value)
                }
            }
            .padding(8)
            .padding(.bottom, 8)
            
            Spacer()
        }
        .frame(width: 230, height: 200)
        .background(Color.backgroundColors.randomElement())
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: .border, radius: 1)
    }
}
