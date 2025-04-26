//
//  Category.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import Foundation
import SwiftUI

struct Category: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let icon: Int?
    let imageURL: String?
    
    public func getIcon() -> Image {
        switch icon ?? 0 {
        case 1:
            return Image(.family)
        case 2:
            return Image(.lifeLessons)
        case 3:
            return Image(.culture)
        case 4:
            return Image(.childhood)
        case 5:
            return Image(.love)
        case 6:
            return Image(.career)
        case 7:
            return Image(.health)
        case 8:
            return Image(.travel)
        case 9:
            return Image(.inspiration)
        case 10:
            return Image(.history)
        case 11:
            return Image(.grief)
        case 12:
            return Image(.joy)
        case 13:
            return Image(.fantasy)
        case 14:
            return Image(.poetry)
        case 15:
            return Image(.dialogues)
        case 16:
            return Image(.other)
        default:
            return Image(systemName: "book")
        }
    }
}

struct CategoriesResponse: Codable {
    let status: Bool
    let message: String
    let categories: [CategoryData]
}

struct CategoryData: Codable {
    let category: Category
    let storyCount: Int
}
