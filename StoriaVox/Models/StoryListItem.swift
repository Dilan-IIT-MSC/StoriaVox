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
    let created: Date
    let duration: Double
    let listenCount: Int
    let author: Author
    let likeCount: Int
    let categories: [Category]?
}

enum LikeAction: String {
    case like = "increase"
    case unlike = "decrease"
}

struct StoryListResponse: Codable {
    let status: Bool
    let message: String
    let category: Category
    let stories: [StoryListItem]
}
