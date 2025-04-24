//
//  StoryTileView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-29.
//

import SwiftUI

struct StoryTileView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: "https://picsum.photos/230/128")) { image in
                image.resizable()
            } placeholder: {
                Color.backgroundColors.randomElement() ?? .gray
            }
            .frame(width: 230, height: 128)
            .background(Color.backgroundColors.randomElement())
            
            Divider()
            
            HStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading) {
                    Text("Cat's Cradle Story")
                        .font(.system(size: 17, weight: .medium))
                    
                    Text("by Anuruddha Rathnayaka")
                        .font(.system(size: 13, weight: .light))
                }
                
                Spacer()
                
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "ear.badge.waveform")
                        .resizable()
                        .foregroundStyle(.secondary)
                        .frame(width: 16, height: 18)
                    
                    Text("123k")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(8)
            .padding(.bottom, 8)
        }
        .background(Color.backgroundColors.randomElement())
        .clipShape(.rect(cornerRadius: 16))
        .frame(width: 230)
        .shadow(color: .border, radius: 1)
    }
}

#Preview {
    StoryTileView()
}
