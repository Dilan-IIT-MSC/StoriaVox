//
//  Story.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-24.
//

import Foundation

struct Story: Codable {
    let id: Int
    let title: String
    let storyUrl: String?
    let genAudioUrl: String?
    let created: String
    let duration: String
    let listenCount: Int
    let status: Int
    let author: Author
    let likeCount: Int
    let categories: [Category]?
    let timelineColors: [TimelineColor]?
    let likes: [Like]?
    let recentListeners: [Listener]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, status, created, duration
        case storyUrl = "story_url"
        case genAudioUrl = "gen_audio_url"
        case listenCount = "listen_count"
        case author, likeCount, categories
        case timelineColors, likes, recentListeners
    }
}

struct Author: Codable {
    let id: Int
    let firstName: String
    let lastName: String?
    let birthDate: String?
}

struct TimelineColor: Codable {
    let id: Int
    let time: String
    let color: String
}

struct Like: Codable {
    let id: Int
    let user: Author
    let updated: String
}

struct Listener: Codable {
    let id: Int
    let user: Author
    let listenTime: String
    let endDuration: String
}

enum LikeAction: String {
    case like = "increase"
    case unlike = "decrease"
}

struct LikeResponse: Codable {
    let likeId: Int?
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case likeId = "like_id"
        case likeCount
    }
}
