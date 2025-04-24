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
    }
    
    func getUser(byId userId: Int, completion: @escaping (Result<User?, NetworkError>) -> Void) {
        NetworkService.shared.performRequest(
            endpoint: Endpoints.userWithId + "\(userId)",
            method: .get,
            dataField: "user",
            completion: completion
        )
    }
    
    func createUser(
        firstName: String,
        lastName: String? = nil,
        birthdate: String? = nil,
        completion: @escaping (Result<User?, NetworkError>) -> Void
    ) {
        var parameters: [String: Any] = ["firstName": firstName]
        
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
            dataField: "user",
            completion: completion
        )
    }
    
    func updateUser(
        userId: Int,
        firstName: String? = nil,
        lastName: String? = nil,
        birthdate: String? = nil,
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
        
        if parameters.isEmpty {
            completion(.failure(.serverMessage("No parameters provided for update")))
            return
        }
        
        NetworkService.shared.performRequest(
            endpoint: Endpoints.userWithId + "\(userId)",
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default,
            dataField: "user",
            completion: completion
        )
    }
    

    func deactivateUser(
        userId: Int,
        completion: @escaping (Result<DeactivateResponse?, NetworkError>) -> Void
    ) {
        NetworkService.shared.performRequest(
            endpoint: Endpoints.userWithId + "\(userId)",
            method: .delete,
            dataField: nil,
            completion: completion
        )
    }
    
    struct DeactivateResponse: Decodable {
        let userId: Int
    }
}
