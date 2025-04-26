//
//  IntegerExtensions.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation

extension Int {
    func abbreviated() -> String {
        let number = Double(self)
        let thousand = 1_000.0
        let million = 1_000_000.0
        let billion = 1_000_000_000.0
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        
        switch number {
        case 0..<thousand:
            return "\(self)"
        case thousand..<million:
            let value = number / thousand
            return (formatter.string(from: NSNumber(value: value)) ?? "\(value)") + "k"
        case million..<billion:
            let value = number / million
            return (formatter.string(from: NSNumber(value: value)) ?? "\(value)") + "M"
        default:
            let value = number / billion
            return (formatter.string(from: NSNumber(value: value)) ?? "\(value)") + "B"
        }
    }
}
