//
//  AmplitudeBar.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-13.
//

import Foundation
import SwiftUI
import AudioKit
import Accelerate

struct AmplitudeBar: View {
    var amplitude: Float
    var barCount: Int
    var barColor: Color
    var paddingFraction: CGFloat = 0.2
    var placeMiddle: Bool = false
    var backgroundColor: Color = .black
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack{
                    Spacer()
                    
                    Rectangle()
                        .fill(barColor)
                        .cornerRadius(3.0)
                        .frame(height: geometry.size.height * CGFloat(amplitude) * 0.4)
                        .animation(.easeOut(duration: 0.15), value: amplitude)
                        .shadow(color: .white.opacity(0.5), radius: 20)
                    if placeMiddle {
                        Spacer()
                    }
                }
                .rotationEffect(.degrees(placeMiddle ? 0 : 225), anchor: .bottom)
            }
            .frame(maxWidth:placeMiddle ? 100 : geometry.size.width/CGFloat(barCount)*2.5)
            .padding(geometry.size.width * paddingFraction / 2)
        }
    }
}
