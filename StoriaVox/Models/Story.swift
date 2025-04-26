//
//  Story.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-14.
//

import Foundation

struct StoryListItem: Codable {
    let id: Int
    let title: String
    let thumbnailUrl: String?
    let duration: String
    let listenCount: Int
    let author: Author
    let likeCount: Int
    let categories: [Category]
}

enum LikeAction: String {
    case like = "increase"
    case unlike = "decrease"
}

struct StoryListResponse: Codable {
    let status: Bool
    let message: String
    let stories: [StoryListItem]
}

struct RecentStory: Codable {
    let id: Int
    let title: String
    let storyUrl: String
    let duration: String
    let lastListenTime: String?
    let listenedDuration: String?
    let created: String?
    let author: Author
    let categories: [Category]
    let isRecommended: Bool?
}
