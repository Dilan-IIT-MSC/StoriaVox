//
//  AudioProgressBar.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import SwiftUI

struct AudioProgressBar: View {
    var value: Double
    var color: Color = .accentColor
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.1)
                    .foregroundColor(color)

                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.7)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                .animation(.linear(duration: 0.1), value: value)
            }
            .cornerRadius(45)
        }
    }
}
