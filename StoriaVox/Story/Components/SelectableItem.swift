//
//  SelectableItem.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

protocol SelectableItem: Identifiable {
    var displayTitle: String { get }
    var displayDescription: String? { get }
    var displayImage: Image? { get }
}

extension Author: SelectableItem {
    var displayTitle: String {
        return "\(firstName) \(lastName ?? "")"
    }
    var displayDescription: String? { nil }
    var displayImage: Image? { Image(systemName: "person.circle") }
}

extension Category: SelectableItem {
    var displayTitle: String { name }
    var displayDescription: String? { description }
    var displayImage: Image? { self.getIcon() }
}


