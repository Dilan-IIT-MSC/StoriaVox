//
//  User.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-14.
//

import Foundation

struct User: Codable {
    let id: Int
    let externalId: String?
    let email: String
    let firstName: String
    let lastName: String?
    let bday: String?
    let bio: String?
    let profileImage: String?
    let status: Int
    let created: String
    let updated: String?
    
    var fullName: String {
        return "\(firstName) \(lastName ?? "")"
    }
}

struct UserResponse: Codable {
    let status: Bool
    let message: String
    let user: User
}

struct AuthorResponse: Codable {
    let status: Bool
    let message: String
    let authors: [Author]
}

struct Author: Codable {
    let id: Int
    let firstName: String
    let lastName: String?
}

extension Author {
    var fullName: String {
        return "\(firstName) \(lastName ?? "")"
    }
}

