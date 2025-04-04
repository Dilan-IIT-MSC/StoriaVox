//
//  BannerType.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation
import SwiftUI

enum BannerType: Int {
    case none
    case info
    case progress
    case success
    case error
    case infoError
    case noConnection
    case noConnectionInfo
    
    var backgroundColor: Color {
        switch self {
        case .none:
            return .clear
        case .info, .noConnectionInfo:
            return Color(hex: "353a3e") ?? Color.gray
        case .progress, .success:
            return Color.accentColor
        case .error, .infoError, .noConnection:
            return Color(hex: "d46c70") ?? Color.errorBackground
        }
    }
    
    var buttonTextColor: Color {
        switch self {
        case .info:
            return Color.accentColor
        case .error, .noConnection, .infoError, .noConnectionInfo:
            return .white
        case .none, .progress, .success:
            return .clear
        }
    }
    
    var buttonText: String? {
        switch self {
        case .info:
            return "Got It"
        case .error, .noConnection:
            return "Try Again"
        case .none, .progress, .success, .infoError, .noConnectionInfo:
            return nil
        }
    }
}

