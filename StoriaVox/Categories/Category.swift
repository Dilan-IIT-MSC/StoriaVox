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
    
    public func getIcon() -> Image {
        switch icon ?? 0 {
        case 1:
            return Image("icon_family")
        case 2:
            return Image("icon_lifeLessons")
        case 3:
            return Image("icon_culture")
        case 4:
            return Image("icon_childhood")
        case 5:
            return Image("icon_love")
        case 6:
            return Image("icon_career")
        case 7:
            return Image("icon_health")
        case 8:
            return Image("icon_travel")
        case 9:
            return Image("icon_inspiration")
        case 10:
            return Image("icon_history")
        case 11:
            return Image("icon_grief")
        case 12:
            return Image("icon_joy")
        case 13:
            return Image("icon_fantasy")
        case 14:
            return Image("icon_poetry")
        case 15:
            return Image("icon_dialogues")
        case 16:
            return Image("icon_other")
        default:
            return Image(systemName: "book")
        }
    }
}
