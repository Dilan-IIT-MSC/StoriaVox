//
//  BannerData.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation

struct BannerData: Identifiable, Equatable {
    static func == (lhs: BannerData, rhs: BannerData) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    var title: String?
    let detail: String
    let type: BannerType
    let isAutoHide: Bool?
    let dismissAction: (() -> Void)?
}
