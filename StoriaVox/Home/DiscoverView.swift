//
//  DiscoverView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct DiscoverView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        NavigationStack(path: $appSettings.homePaths) {
            ZStack(alignment: .top) {
                Color.background
                
                VStack(alignment: .leading) {
                    headerView()
                    
                    ScrollView(showsIndicators: false) {
                        trendingSection()
                        
                        Divider()
                        
                        recentlyListenedSection()
                        
                        Divider()
                        
                        categoriesSection()
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, safeAreaInsets.top)

            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

extension DiscoverView {
    @ViewBuilder
    func headerView() -> some View {
        HStack(alignment: .center, spacing: 8) {
            ZStack {
                Circle()
                    .fill(.green50)
                    .frame(width: 50, height: 50)
                    .shadow(radius: 1)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.accent)
                    .font(.system(size: 32, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Dilan Anuruddha")
                    .font(.system(size: 17, weight: .medium))
                
                Text("Tell your life story")
                    .font(.system(size: 13, weight: .light))
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "ear.badge.waveform")
                    .resizable()
                    .foregroundStyle(.accent)
                    .frame(width: 16, height: 18)
                
                Text("32k")
                    .font(.system(size: 14, weight: .light))
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    @ViewBuilder
    func trendingSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending Stories")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
            }
            .padding(.top, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<10) { index in
                        StoryTileView()
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    func recentlyListenedSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recently Listened")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
            }
            .padding(.top, 16)
            
            ForEach(0..<2) { index in
                RecentlyListenedRowView()
            }
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    func categoriesSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Listen by Category")
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
                Button {
                    appSettings.homePaths.append(.allCategories)
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("view all")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.secondValue)
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondValue)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        Button {
                            appSettings.homePaths.append(.storyListing)
                        } label: {
                            Text("Category \(index + 1)")
//                            CategoryTileView(category: appSettings.storyCategories[index])
//                                .contentShape(Rectangle())
                        }
                    }
                }
            }
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .allCategories:
                AllCategoriesView().environmentObject(appSettings)
            case .storyListing:
                AllStoriesView().environmentObject(appSettings)
            default:
                Text("None \(route)")
            }
        }
    }
    
}

#Preview {
    DiscoverView().environmentObject(AppSettings())
}
