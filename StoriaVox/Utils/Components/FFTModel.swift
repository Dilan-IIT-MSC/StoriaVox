//
//  FFTModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-13.
//

import Foundation
import Accelerate
import SwiftUI
import AudioKit

class FFTModel: ObservableObject {
    @Published var amplitudes: [Float?] = Array(repeating: nil, count: 50)
    var nodeTap: FFTTap!
    var node: Node?
    var numberOfBars: Int = 50
    var maxAmplitude: Float = 0.0
    var minAmplitude: Float = -70.0
    var referenceValueForFFT: Float = 12.0
    
    func updateNode(_ node: Node, fftValidBinCount: FFTValidBinCount? = nil) {
        if node !== self.node {
            self.node = node
            nodeTap = FFTTap(node, fftValidBinCount: fftValidBinCount, callbackQueue: .main) { fftData in
                self.updateAmplitudes(fftData)
            }
            nodeTap.isNormalized = false
            nodeTap.start()
        }
    }
    
    func updateAmplitudes(_ fftFloats: [Float]) {
        var fftData = fftFloats
        for index in 0 ..< fftData.count {
            if fftData[index].isNaN { fftData[index] = 0.0 }
        }
        
        var one = Float(1.0)
        var zero = Float(0.0)
        var decibelNormalizationFactor = Float(1.0 / (maxAmplitude - minAmplitude))
        var decibelNormalizationOffset = Float(-minAmplitude / (maxAmplitude - minAmplitude))
        
        var decibels = [Float](repeating: 0, count: fftData.count)
        vDSP_vdbcon(fftData, 1, &referenceValueForFFT, &decibels, 1, vDSP_Length(fftData.count), 0)
        
        vDSP_vsmsa(decibels,
                   1,
                   &decibelNormalizationFactor,
                   &decibelNormalizationOffset,
                   &decibels,
                   1,
                   vDSP_Length(decibels.count))
        
        vDSP_vclip(decibels, 1, &zero, &one, &decibels, 1, vDSP_Length(decibels.count))

        DispatchQueue.main.async {
            self.amplitudes = decibels
        }
    }
    
    func mockAudioInput() {
        var mockFloats = [Float]()
        for _ in 0...65 {
            mockFloats.append(Float.random(in: 0...0.1))
        }
        updateAmplitudes(mockFloats)
        let waitTime: TimeInterval = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            self.mockAudioInput()
        }
    }
}
