//
//  AudioVisualisationView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-02.
//

import SwiftUI

struct AudioVisualisationView: View {
    let amplitudes: [CGFloat] = (0..<50).map { _ in CGFloat.random(in: 0...1) }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 3) {
                ForEach(0..<amplitudes.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.accentColor)
                        .frame(width: 6, height: 60 * amplitudes[index])
                }
            }
        }
    }
}

#Preview {
    AudioVisualisationView()
}
