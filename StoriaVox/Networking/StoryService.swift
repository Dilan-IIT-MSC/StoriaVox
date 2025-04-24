//
//  StoryService.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation
import Alamofire

// MARK: - Story Response
struct StoryUploadResponse: Codable {
    let status: Bool
    let message: String
}


// MARK: - Story Service
class StoryService {
    static let shared = StoryService()
    
    @discardableResult func uploadStory(
        title: String,
        audioURL: URL,
        categoryIds: [Int],
        completion: @escaping (Result<StoryUploadResponse, Error>) -> Void
    ) -> UploadRequest? {
        // Error checking
        guard !title.isEmpty else {
            completion(.failure(NSError(domain: "StoryService", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Title cannot be empty"])))
            return nil
        }
        
        guard categoryIds.count <= 3 else {
            completion(.failure(NSError(domain: "StoryService", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Maximum 3 categories allowed"])))
            return nil
        }
        
        guard FileManager.default.fileExists(atPath: audioURL.path) else {
            completion(.failure(NSError(domain: "StoryService", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Audio file not found"])))
            return nil
        }
        
        let userId = 2
        
        let categoriesJSON: String
        do {
            let data = try JSONSerialization.data(withJSONObject: categoryIds, options: [])
            categoriesJSON = String(data: data, encoding: .utf8) ?? "[]"
        } catch {
            completion(.failure(error))
            return nil
        }
        
        var uploadRequest: UploadRequest?
        uploadRequest = NetworkService.shared.upload(
            multipartFormData: { multipartFormData in
                if let userIdData = "\(userId)".data(using: .utf8) {
                    multipartFormData.append(userIdData, withName: "user_id")
                }
                
                if let titleData = title.data(using: .utf8) {
                    multipartFormData.append(titleData, withName: "title")
                }
                
                if let categoriesData = categoriesJSON.data(using: .utf8) {
                    multipartFormData.append(categoriesData, withName: "categories")
                }
                
                multipartFormData.append(audioURL, withName: "audio", fileName: audioURL.lastPathComponent, mimeType: "audio/aac")
            },
            to: "story/upload",
            method: .post,
            authType: .function
        ) { (result: Result<StoryUploadResponse, Error>) in
            switch result {
            case .success(let uploadResponse):
                if uploadResponse.status{
                    completion(.success(uploadResponse))
                } else {
                    let errorMessage = uploadResponse.message
                    completion(.failure(NSError(domain: "StoryService", code: 1004, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        uploadRequest?.uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        
        return uploadRequest
    }
}

