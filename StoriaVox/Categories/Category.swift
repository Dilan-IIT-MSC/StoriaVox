//
//  Category.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import Foundation
import SwiftUI

struct Category: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let icon: Image
}
