//
//  Dashboard.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation

struct DashboardResponse: Codable {
    let status: Bool
    let message: String
    let dashboard: Dashboard
}

struct Dashboard: Codable {
    let trendingStories: [StoryListItem]
    let recentlyListened: [RecentStory]
    let trendingCategories: [CategoryData]
}
