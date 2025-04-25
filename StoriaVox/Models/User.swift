//
//  User.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-14.
//

import Foundation

struct User: Codable {
    let id: Int
    let externalId: String
    let email: String
    let firstName: String
    let lastName: String?
    let bday: String?
    let bio: String?
    let profileImage: String?
    let status: Int
    let created: String?
    let updated: String?
}

