//
//  CircularProgress.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation
import SwiftUI

struct CircularProgress: View {
    @State private var degreesRotating = 0.0
    var body: some View {
        Circle()
            .trim(from: 0.0, to: min(0.90, 1.0))
            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .foregroundColor(.white.opacity(0.8))
            .rotationEffect(.degrees(degreesRotating))
            .onAppear {
                withAnimation(.linear(duration: 1)
                    .speed(0.8).repeatForever(autoreverses: false)) {
                        degreesRotating = 360.0
                    }
            }
            .frame(width: 16, height: 16, alignment: .center)
    }
}

