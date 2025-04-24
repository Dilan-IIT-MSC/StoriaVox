//
//  User.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-14.
//

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String?
    let bday: String?
    let status: Int
    let profileImage: String?
}

struct DeactivateResponse: Decodable {
    let userId: Int
}
