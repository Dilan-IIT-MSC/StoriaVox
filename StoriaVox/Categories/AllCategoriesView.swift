//
//  AllCategoriesView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-30.
//

import SwiftUI

struct AllCategoriesView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var loadingState: LoadingState
    @EnvironmentObject private var bannerState: BannerState
    @StateObject var viewModel: CategoryViewModel = .init()
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
                        ForEach(0..<viewModel.categories.count, id: \.self) { index in
                            Button {
                                appSettings.homePaths.append(.storyListing)
                            } label: {
                                CategoryTileView(categoryData: viewModel.categories[index])
                                    .contentShape(Rectangle())
                            }
                            .id(viewModel.categories[index].category.id)
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchCategories()
                }
                
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
        }
        .banner(isPresent: $bannerState.isShowBanner)
        .navigationTitle("All Categories")
        .onAppear {
            viewModel.fetchCategories()
        }
    }
}

#Preview {
    AllCategoriesView().environmentObject(AppSettings())
}
