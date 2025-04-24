//
//  MetaDataViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation
import SwiftUI
import AudioKit
import AVFoundation

class MetaDataViewModel: ObservableObject {
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var meterTimer: Timer?
    @Published var audioURL: URL?
    @Published var isPlaying = false
    @Published var playbackTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var errorMessage: String?
    @Published var selectedCategories: Set<Int32> = []
    
        
        @Published var amplitudes: [CGFloat] = {
            var amps = [CGFloat]()
            let barCount = 50
            
            for i in 0..<barCount {
                let x = Double(i) / Double(barCount)
                let value = 0.2 * exp(-pow(4.0 * (x - 0.5), 2))
                amps.append(CGFloat(value))
            }
            return amps
        }()
        
        init(audioURL: URL? = nil) {
            self.audioURL = audioURL
            if let url = audioURL {
                convertAndLoadAudio(from: url)
            }
        }
        
        private func convertAndLoadAudio(from url: URL) {
            if loadAudioDirectly(url: url) {
                return
            }
            
            do {
                let tempDirectoryURL = FileManager.default.temporaryDirectory
                let tempFileURL = tempDirectoryURL.appendingPathComponent("temp_audio_\(Date().timeIntervalSince1970).m4a")
                let asset = AVAsset(url: url)
                
                if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
                    exportSession.outputURL = tempFileURL
                    exportSession.outputFileType = .m4a
                    exportSession.shouldOptimizeForNetworkUse = true
                    
                    let group = DispatchGroup()
                    group.enter()
                    
                    exportSession.exportAsynchronously {
                        defer { group.leave() }
                        
                        if exportSession.status == .completed {
                            DispatchQueue.main.async {
                                _ = self.loadAudioDirectly(url: tempFileURL)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.createSilentAudio()
                            }
                        }
                    }
                    
                    let result = group.wait(timeout: .now() + 10)
                    if result == .timedOut {
                        self.createSilentAudio()
                    }
                } else {
                    self.createSilentAudio()
                }
            } catch {
                print("Error reading audio data: \(error.localizedDescription)")
                self.errorMessage = "Error reading audio file: \(error.localizedDescription)"
                self.alertMessage = "There was a problem with the audio file. You can continue adding metadata, but audio preview is unavailable."
                self.showAlert = true
                self.createSilentAudio()
            }
        }
        
        private func loadAudioDirectly(url: URL) -> Bool {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
    
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.isMeteringEnabled = true
                audioPlayer?.prepareToPlay()
                generateWaveform()
                
                if let player = audioPlayer {
                    duration = player.duration
                    print("Audio loaded successfully - Duration: \(duration) seconds")
                    return true
                }
                return false
            } catch {
                print("Direct audio loading failed: \(error.localizedDescription) (URL: \(url.path))")
                return false
            }
        }
        
        private func generateWaveform() {
            guard let player = audioPlayer, player.duration > 0 else { return }
            let numberOfSamples = min(Int(player.duration * 10), 500)
            let samplingInterval = player.duration / TimeInterval(amplitudes.count)
            

            var newAmplitudes = [CGFloat](repeating: 0.1, count: amplitudes.count)
            let originalVolume = player.volume
            player.volume = 0
            player.play()
            
            for i in 0..<amplitudes.count {
                let playbackPosition = TimeInterval(i) * samplingInterval
                if playbackPosition < player.duration {
                    player.currentTime = playbackPosition
                    player.updateMeters()
                    let powerLevel = player.averagePower(forChannel: 0)
                    let normalizedValue = CGFloat(max(0, (powerLevel + 50) / 50))
                    newAmplitudes[i] = max(0.05, normalizedValue * 0.8)
                }
            }
            player.stop()
            player.volume = originalVolume
            player.currentTime = 0
            
            DispatchQueue.main.async {
                self.amplitudes = newAmplitudes
            }
        }
        
        private func createSilentAudio() {
            let sampleRate = 44100.0
            let duration = 30.0
            let numSamples = Int(sampleRate * duration)
            
            let silentBuffer = [UInt8](repeating: 128, count: numSamples)
            
            do {
                audioPlayer = try AVAudioPlayer(data: Data(silentBuffer))
                audioPlayer?.prepareToPlay()
                self.duration = duration
            } catch {
                print("Failed to create silent audio: \(error.localizedDescription)")
                self.duration = 600.0
            }
        }
        
        func startPlayback() {
            guard let player = audioPlayer else {
                if let url = audioURL {
                    convertAndLoadAudio(from: url)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.startPlayback()
                    }
                }
                return
            }
            
            player.play()
            isPlaying = true
            startTimer()
            startMeterTimer()
        }
        
        func pausePlayback() {
            guard let player = audioPlayer, isPlaying else { return }
            player.pause()
            isPlaying = false
            stopTimer()
            stopMeterTimer()
        }
        
        func stopPlayback() {
            guard let player = audioPlayer else { return }
            
            player.stop()
            player.currentTime = 0
            isPlaying = false
            playbackTime = 0
            stopTimer()
            stopMeterTimer()
            
            print("Stopped audio playback")
        }
        
        private func startTimer() {
            stopTimer()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self, self.isPlaying, let player = self.audioPlayer else { return }
                self.playbackTime = player.currentTime
                if !player.isPlaying && player.currentTime >= player.duration - 0.1 {
                    self.stopPlayback()
                }
            }
        }
        
        private func startMeterTimer() {
            stopMeterTimer()
            guard let player = audioPlayer, player.isMeteringEnabled else { return }
            
            meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self = self, self.isPlaying else { return }
                
                self.updateAmplitudesFromMeters()
            }
        }
        
        private func updateAmplitudesFromMeters() {
            guard let player = audioPlayer, player.isMeteringEnabled else { return }
            player.updateMeters()
            let percentage = min(1.0, player.currentTime / player.duration)
            let activeBarCount = Int(percentage * Double(amplitudes.count))
            var newAmplitudes = amplitudes
            
            for i in 0..<amplitudes.count {
                if isPlaying {
                    if i <= activeBarCount {
                        let powerLevel = player.averagePower(forChannel: 0)
                        let normalizedValue = CGFloat(max(0, (powerLevel + 50) / 50))
                        let randomFactor = CGFloat.random(in: 0.8...1.2)
                        let newAmplitude = max(0.05, min(1.0, normalizedValue * randomFactor))
                        newAmplitudes[i] = (newAmplitudes[i] * 0.7) + (newAmplitude * 0.3)
                    } else {
                        let randomFactor = CGFloat.random(in: 0.98...1.02)
                        newAmplitudes[i] = min(1.0, max(0.05, newAmplitudes[i] * randomFactor))
                    }
                }
            }

            DispatchQueue.main.async {
                self.amplitudes = newAmplitudes
            }
        }
        
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
        
        private func stopMeterTimer() {
            meterTimer?.invalidate()
            meterTimer = nil
        }
        
        // MARK: - Utility Methods
        func formatTime(_ timeInterval: TimeInterval) -> String {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        // MARK: - Cleanup
        func cleanup() {
            if isPlaying {
                stopPlayback()
            }
            stopTimer()
            stopMeterTimer()
            
            // Reset values
            playbackTime = 0
            audioPlayer = nil
            
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                print("Could not deactivate audio session: \(error.localizedDescription)")
            }
        }
        
        deinit {
            cleanup()
        }
}
