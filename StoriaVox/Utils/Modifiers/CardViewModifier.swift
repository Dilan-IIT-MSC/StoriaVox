//
//  CardViewModifier.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-02.
//

import Foundation
import SwiftUI

struct CardView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.whiteBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}
