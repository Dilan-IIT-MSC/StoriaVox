//
//  ColorExtensions.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-21.
//

import Foundation
import SwiftUI

extension Color {
    // MARK: Hex Color
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var opacity: Double = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            red = Double((rgb & 0xFF0000) >> 16) / 255.0
            green = Double((rgb & 0x00FF00) >> 8) / 255.0
            blue = Double(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            red = Double((rgb & 0xFF000000) >> 24) / 255.0
            green = Double((rgb & 0x00FF0000) >> 16) / 255.0
            blue = Double((rgb & 0x0000FF00) >> 8) / 255.0
            opacity = Double(rgb & 0x000000FF) / 255.0

        } else {
            red = 0
            green = 0
            blue = 0
            opacity = 1.0

        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static let backgroundColors: [Color] = [
        .amber50,
        .blue50,
        .brown50,
        .cyan50,
        .deepOrange50,
        .deepPurple50,
        .green50,
        .indigo50,
        .lightBlue50,
        .lightGreen50,
        .lime50,
        .orange50,
        .pink50,
        .purple50,
        .red50,
        .teal50,
        .yellow50,
    ]
}
