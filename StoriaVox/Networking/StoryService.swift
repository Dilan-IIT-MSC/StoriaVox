//
//  StoryService.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation
import Alamofire

class StoryService {
    static let shared = StoryService()
    
    private init() {}
    
    private enum Endpoints {
        static let story = "story"
        static let storyWithId = "story/"
        static let storyLike = "story/like"
        static let storyUpload = "story/upload"
        static let stories = "stories"
    }
    
    func getStories(
        authorId: Int? = nil,
        categoryId: Int? = nil,
        order: String = "ascending",
        completion: @escaping (Result<StoryListResponse, NetworkError>) -> Void
    ) {
        var parameters: [String: Any] = ["order": order]
        
        if let userId = authorId {
            parameters["user_id"] = userId
        }
        
        if let categoryId = categoryId {
            parameters["category_id"] = categoryId
        }
        
        NetworkService.shared.performRequest(
            endpoint: Endpoints.stories,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            completion: completion
        )
    }
    
    func getStoryDetail(
        storyId: Int,
        completion: @escaping (Result<StoryListItem?, NetworkError>) -> Void
    ) {
        NetworkService.shared.performRequest(
            endpoint: Endpoints.storyWithId + "\(storyId)",
            method: .get,
            completion: completion
        )
    }
    
    func uploadStory(
        userId: Int,
        title: String,
        categories: [Int],
        audioData: Data,
        progressHandler: ((Double) -> Void)? = nil,
        completion: @escaping (Result<StoryUploadResponse?, NetworkError>) -> Void
    ) {
        NetworkService.shared.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(Data("\(userId)".utf8), withName: "user_id")
                multipartFormData.append(Data(title.utf8), withName: "title")
                if let categoriesData = try? JSONSerialization.data(withJSONObject: categories),
                   let categoriesString = String(data: categoriesData, encoding: .utf8) {
                    multipartFormData.append(Data(categoriesString.utf8), withName: "categories")
                }
                multipartFormData.append(audioData, withName: "audio", fileName: "recording.aac", mimeType: "audio/aac")
            },
            to: Endpoints.storyUpload,
            dataField: "story",
            uploadProgress: { progress in
                progressHandler?(progress.fractionCompleted)
            },
            completion: completion
        )
    }
}
