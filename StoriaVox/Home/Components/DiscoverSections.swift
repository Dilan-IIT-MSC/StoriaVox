//
//  DiscoverSections.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

extension DiscoverView {
    @ViewBuilder
    func headerView() -> some View {
        if let user = UserDefaultsManager.shared.loggedInUser {
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
                    Text(user.fullName)
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
                    
                    Text("5")
                        .font(.system(size: 14, weight: .light))
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
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
                    ForEach(Array((viewModel.dashboardData?.trendingStories ?? []).enumerated()), id: \.element.id) { _, story in
                        Button {
                            
                        } label: {
                            StoryTileView(story: story)
                                .contentShape(Rectangle())
                        }
                        .frame(height: 240)
                    }
                }
                .frame(height: 250)
            }
        }
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    func recentlyListenedSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                if let item = viewModel.dashboardData?.recentlyListened.first {
                    if item.isRecommended ?? false {
                        Text("Recommended")
                            .font(.system(size: 20, weight: .semibold))
                    } else {
                        Text("Recently Listened")
                            .font(.system(size: 20, weight: .semibold))
                    }
                } else {
                    Text("Recently Listened")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                Spacer()
            }
            .padding(.top, 16)
            
            ForEach(Array((viewModel.dashboardData?.recentlyListened ?? []).enumerated()), id: \.element.id) { _, story in
                RecentlyListenedRowView(story: story)
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
                    ForEach(Array((viewModel.dashboardData?.trendingCategories ?? []).enumerated()), id: \.element.category.id) { _, category in
                        Button {
                            appSettings.homePaths.append(.storyListing)
                        } label: {
                            CategoryTileView(categoryData: category)
                                .contentShape(Rectangle())
                        }
                        .frame(width: 180)
                    }
                }
                .frame(height: 250)
            }
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .allCategories:
                AllCategoriesView().environmentObject(appSettings)
            case .storyListing:
                AllStoriesView().environmentObject(appSettings)
            case .storyDetail(let id):
                if let story = viewModel.dashboardData?.trendingStories.first(where: {$0.id == id}) {
                    ListenStoryView(story: story).environmentObject(appSettings)
                } else {
                    EmptyView()
                }
                
            default:
                Text("None \(route)")
            }
        }
    }
    
}
