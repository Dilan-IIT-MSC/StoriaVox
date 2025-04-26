//
//  UserService.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-14.
//

import Foundation
import Alamofire

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    private enum Endpoints {
        static let user = "user"
        static let userWithId = "user/"
        static let userByEmail = "user/email/"
        static let profileImage = "/profile-image"
        static let userCategories = "user_preferred_categories"
    }
    
    func getUser(byId userId: Int, completion: @escaping (Result<User?, NetworkError>) -> Void) {
        NetworkService.shared.performRequest(
            endpoint: Endpoints.userWithId + "\(userId)",
            method: .get,
            completion: completion
        )
    }
    
    func getUserByEmail(email: String, completion: @escaping (Result<User?, NetworkError>) -> Void) {
        NetworkService.shared.performRequest(
            endpoint: Endpoints.userByEmail + email,
            method: .get,
            completion: completion
        )
    }
    
    func createUser(
        externalId: String,
        email: String,
        firstName: String,
        lastName: String? = nil,
        birthdate: String? = nil,
        completion: @escaping (Result<User?, NetworkError>) -> Void
    ) {
        var parameters: [String: Any] = [
            "externalId": externalId,
            "email": email,
            "firstName": firstName
        ]
        
        if let lastName = lastName {
            parameters["lastName"] = lastName
        }
        
        if let birthdate = birthdate {
            parameters["bday"] = birthdate
        }
        
        NetworkService.shared.performRequest(
            endpoint: Endpoints.user,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            completion: completion
        )
    }
    
    // MARK: - Update User
    func updateUser(
        userId: Int,
        firstName: String? = nil,
        lastName: String? = nil,
        birthdate: String? = nil,
        bio: String? = nil,
        completion: @escaping (Result<User?, NetworkError>) -> Void
    ) {
        var parameters: [String: Any] = [:]
        
        if let firstName = firstName {
            parameters["firstName"] = firstName
        }
        
        if let lastName = lastName {
            parameters["lastName"] = lastName
        }
        
        if let birthdate = birthdate {
            parameters["bday"] = birthdate
        }
        
        if let bio = bio {
            parameters["bio"] = bio
        }
        
        if parameters.isEmpty {
            completion(.failure(.serverMessage("No parameters provided for update")))
            return
        }
        
        NetworkService.shared.performRequest(
            endpoint: Endpoints.userWithId + "\(userId)",
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default,
            completion: completion
        )
    }
    
    // MARK: - Upload Profile Image
    func uploadProfileImage(
        userId: Int,
        imageData: Data,
        completion: @escaping (Result<User?, NetworkError>) -> Void
    ) {
        NetworkService.shared.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    imageData,
                    withName: "image",
                    fileName: "profile_\(userId)_\(Date().timeIntervalSince1970).jpg",
                    mimeType: "image/jpeg"
                )
            },
            to: Endpoints.userWithId + "\(userId)" + Endpoints.profileImage,
            dataField: "user",
            completion: completion
        )
    }
    
    func addUserCategories(
            userId: Int,
            categories: [Int],
            completion: @escaping (Result<Bool, NetworkError>) -> Void
        ) {
            let parameters: [String: Any] = [
                "user_id": userId,
                "categories": categories
            ]
            
//            NetworkService.shared.performRequest(
//                endpoint: Endpoints.userCategories,
//                method: .post,
//                parameters: parameters,
//                encoding: JSONEncoding.default,
//                completion: { (result: Result<EmptyResponse?, NetworkError>) in
//                    switch result {
//                    case .success:
//                        completion(.success(true))
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//            )
        }
}
