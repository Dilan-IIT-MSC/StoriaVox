//
//  AudioVisualisationView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-02.
//

import SwiftUI

struct AudioVisualisationView: View {
    var amplitudes: [CGFloat]
    var isPlaying: Bool
    var activeColor: Color
    var inactiveColor: Color
    
    init(
        amplitudes: [CGFloat] = (0..<50).map { _ in CGFloat.random(in: 0...1) },
        isPlaying: Bool = false,
        activeColor: Color = .green,
        inactiveColor: Color = Color.gray.opacity(0.3)
    ) {
        self.amplitudes = amplitudes
        self.isPlaying = isPlaying
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<amplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(isPlaying ? activeColor : inactiveColor)
                    .frame(width: 3, height: max(3, 60 * amplitudes[index]))
                    .animation(.easeInOut(duration: 0.1), value: amplitudes[index])
            }
        }
        .frame(height: 60)
        .padding(.vertical, 10)
    }
}

#Preview {
    VStack(spacing: 20) {
        AudioVisualisationView(isPlaying: false)
        AudioVisualisationView(isPlaying: true)
    }
}
