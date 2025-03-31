//
//  AllCategoriesView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-30.
//

import SwiftUI

struct AllCategoriesView: View {
    @EnvironmentObject var appSettings: AppSettings
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<appSettings.storyCategories.count, id: \.self) { index in
                            CategoryTileView(category: appSettings.storyCategories[index])
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("All Categories")
    }
}

#Preview {
    AllCategoriesView().environmentObject(AppSettings())
}
