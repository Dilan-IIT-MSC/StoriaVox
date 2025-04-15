//
//  FFTView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-13.
//


import SwiftUI
import AudioKit

public struct FFTView: View {
    @StateObject var fft = FFTModel()
    private var barColor: Color
    private var paddingFraction: CGFloat
    private var placeMiddle: Bool
    private var node: Node
    private var barCount: Int
    private var fftValidBinCount: FFTValidBinCount?
    private var minAmplitude: Float
    private var maxAmplitude: Float
    private let defaultBarCount: Int = 64
    private let maxBarCount: Int = 128
    private var backgroundColor: Color
    
    public init(_ node: Node,
                barColor: Color = Color.green.opacity(0.5),
                paddingFraction: CGFloat = 0.2,
                placeMiddle: Bool = true,
                validBinCount: FFTValidBinCount? = nil,
                barCount: Int? = nil,
                maxAmplitude: Float = -10.0,
                minAmplitude: Float = -150.0,
                backgroundColor: Color = Color.clear)
    {
        self.node = node
        self.barColor = barColor
        self.paddingFraction = paddingFraction
        self.placeMiddle = placeMiddle
        self.maxAmplitude = maxAmplitude
        self.minAmplitude = minAmplitude
        fftValidBinCount = validBinCount
        self.backgroundColor = backgroundColor
        
        if maxAmplitude < minAmplitude {
            fatalError("Maximum amplitude cannot be less than minimum amplitude")
        }
        if minAmplitude > 0.0 || maxAmplitude > 0.0 {
            fatalError("Amplitude values must be less than zero")
        }
        
        if let requestedBarCount = barCount {
            self.barCount = requestedBarCount
        } else {
            if let fftBinCount = fftValidBinCount {
                if Int(fftBinCount.rawValue) > maxBarCount - 1 {
                    self.barCount = maxBarCount
                } else {
                    self.barCount = Int(fftBinCount.rawValue)
                }
            } else {
                self.barCount = defaultBarCount
            }
        }
    }
    
    @State private var degress: Double = 0
    @State private var isRotating = 0.0
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        
        GeometryReader { geometry in
            if !placeMiddle {
                ZStack() {
                    ForEach(0 ..< barCount, id: \.self) { i in
                        if i < fft.amplitudes.count {
                            if let amplitude = fft.amplitudes[i] {
                                AmplitudeBar(amplitude: amplitude,
                                              barCount: barCount,
                                              barColor: barColor,
                                              paddingFraction: paddingFraction,
                                              placeMiddle: placeMiddle)
                                .rotationEffect(.degrees(Double(i)/Double(barCount)*360.0), anchor: .center)
                            }
                        } else {
                            AmplitudeBar(amplitude: 0.0,
                                          barCount: barCount,
                                          barColor: barColor,
                                          paddingFraction: paddingFraction,
                                          placeMiddle: placeMiddle,
                                          backgroundColor: backgroundColor)
                        }
                    }
                }
                .padding(geometry.size.width*0.25)
                
            } else {
                HStack(spacing: 0) {
                    
                    ForEach(0 ..< barCount, id: \.self) { i in
                        if i < fft.amplitudes.count {
                            if let amplitude = fft.amplitudes[i] {
                                
                                //barColor opacity set by amplitude
                                AmplitudeBar(amplitude: amplitude,
                                              barCount: barCount,
                                              barColor: barColor.opacity(Double(amplitude)*0.8),
                                              paddingFraction: paddingFraction,
                                              placeMiddle: placeMiddle)
                            }
                        } else {
                            AmplitudeBar(amplitude: 0.0,
                                          barCount: barCount,
                                          barColor: barColor,
                                          paddingFraction: paddingFraction,
                                          placeMiddle: placeMiddle,
                                          backgroundColor: backgroundColor)
                        }
                    }
                }
                .padding(20)
            }
        }.onReceive(timer) {_ in
            isRotating += 2
        }
        .rotationEffect(.degrees(placeMiddle ? 0 :isRotating))
        .animation(.linear(duration: 1), value: isRotating)
        .onAppear {
            fft.updateNode(node, fftValidBinCount: self.fftValidBinCount)
            fft.maxAmplitude = self.maxAmplitude
            fft.minAmplitude = self.minAmplitude
        }
        .onDisappear() {
            timer.upstream.connect().cancel()
        }
        .drawingGroup()
    }
}
