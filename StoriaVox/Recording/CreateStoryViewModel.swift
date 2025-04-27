//
//  CreateStoryViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-13.
//

import SwiftUI
import AudioKit
import AVFoundation

extension AVAudioFile {
    var duration: TimeInterval {
        let sampleRate = Double(processingFormat.sampleRate)
        let sampleCount = Double(length)
        return sampleCount / sampleRate
    }
}

class CreateStoryViewModel: ObservableObject {
    private let MAX_RECORDING_TIME: TimeInterval = 600
    var engine: AudioEngine?
    private var mixer: Mixer?
    private var recorder: NodeRecorder?
    private var player: AudioPlayer?
    private var timer: Timer?
    @Published var audioNode: Node?
    @Published var recordingURL: URL?
    @Published var isRecording = false
    @Published var isPaused = false
    @Published var isPlaying = false
    @Published var recordingTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var playbackTime: TimeInterval = 0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var errorMessage: String?
    @Published var maxTimeReached = false
    @Published var isEngineRunning = false
    
    init() {}
    
    private func setupAudioSession() -> Bool {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            return true
        } catch {
            errorMessage = "Failed to set up audio session: \(error.localizedDescription)"
            alertMessage = "Could not access microphone: \(error.localizedDescription)"
            showAlert = true
            return false
        }
    }
    
    func setupAudioEngine() -> Bool {
        cleanupEngine()
        guard setupAudioSession() else { return false }
        
        do {
            engine = AudioEngine()
            guard let engine = engine else { return false }
            
            guard let input = engine.input else {
                errorMessage = "Could not access microphone input"
                alertMessage = "Microphone not available. Please check your device settings."
                showAlert = true
                return false
            }
            
            audioNode = input
            mixer = Mixer(input)
            engine.output = mixer
            try engine.start()
            isEngineRunning = true
            
            return true
        } catch {
            errorMessage = "Could not start audio engine: \(error.localizedDescription)"
            alertMessage = "Failed to start audio recording system: \(error.localizedDescription)"
            showAlert = true
            return false
        }
    }
    
    // MARK: - Engine Control
    func startEngine() {
        if !isEngineRunning {
            _ = setupAudioEngine()
        }
    }
    
    func stopEngine() {
        stopTimer()
        if isRecording {
            _ = stopRecording()
        }
        if isPlaying {
            stopPlayback()
        }
        engine?.stop()
        isEngineRunning = false
    }
    
    private func cleanupEngine(preserveRecording: Bool = true) {
        stopTimer()
        
        if isRecording || isPaused {
            _ = stopRecording()
        }
        
        if isPlaying {
            stopPlayback()
        }
        
        if !preserveRecording {
            recorder = nil
        }

        engine?.stop()
        engine = nil
        player = nil
        mixer = nil
        audioNode = nil
        isEngineRunning = false
        isRecording = false
        isPaused = false
        isPlaying = false
    }
    
    // MARK: - Recording Methods
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    completion(true)
                } else {
                    self.alertMessage = "Microphone access is required to record stories. Please enable it in Settings."
                    self.showAlert = true
                    completion(false)
                }
            }
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }

        if !isEngineRunning {
            guard setupAudioEngine() else { return }
        }

        guard let mixer = self.mixer else {
            alertMessage = "Audio system not ready. Please try again."
            showAlert = true
            return
        }
        
        if !isPaused {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let recordingsDirectory = documentsPath.appendingPathComponent("Recordings", isDirectory: true)
            
            do {
                if !FileManager.default.fileExists(atPath: recordingsDirectory.path) {
                    try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true)
                }
            } catch {
                print("Could not create recordings directory: \(error.localizedDescription)")
            }

            if isRecording {
                recorder?.stop()
            }
            
            recordingTime = 0
            duration = 0
            maxTimeReached = false
            
            do {
                recorder = try NodeRecorder(node: mixer,
                                          fileDirectoryURL: recordingsDirectory,
                                          shouldCleanupRecordings: false)
            } catch {
                alertMessage = "Could not create recorder: \(error.localizedDescription)"
                showAlert = true
                return
            }
        }

        do {
            try recorder?.record()
            isRecording = true
            isPaused = false
            startTimer()
        } catch {
            alertMessage = "Could not start recording: \(error.localizedDescription)"
            showAlert = true
            errorMessage = "Recording error: \(error.localizedDescription)"
        }
    }
    
    func pauseRecording() {
        guard isRecording, !isPaused, let recorder = recorder else { return }
        recorder.stop()
        if let audioFile = recorder.audioFile {
            recordingURL = audioFile.url
            print("Recording paused, file saved at: \(audioFile.url.path)")
        }
        
        isPaused = true
        isRecording = false
        stopTimer()
        duration = max(duration, recordingTime)
    }
    
    func stopRecording() -> URL? {
        guard let recorder = recorder else { return nil }
        recorder.stop()

        if let audioFile = recorder.audioFile {
            recordingURL = audioFile.url
            print("Recording stopped, file saved at: \(audioFile.url.path)")
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let timestamp = Int(Date().timeIntervalSince1970)
            let permanentURL = documentsPath.appendingPathComponent("recording_\(timestamp).m4a")
            
            do {
                if FileManager.default.fileExists(atPath: permanentURL.path) {
                    try FileManager.default.removeItem(at: permanentURL)
                }
                try FileManager.default.copyItem(at: audioFile.url, to: permanentURL)
                recordingURL = permanentURL
                print("Recording copied to permanent location: \(permanentURL.path)")
            } catch {
                print("Failed to copy recording to permanent location: \(error.localizedDescription)")
            }
        } else {
            print("No audio file available after stopping recording")
        }
        
        isRecording = false
        isPaused = false
        stopTimer()
        duration = max(duration, recordingTime)
        return recordingURL
    }
    
    func setupPlayback(for url: URL? = nil) {
        guard let audioURL = url ?? recordingURL else {
            alertMessage = "No audio recording available"
            showAlert = true
            return
        }
        
        if !isEngineRunning {
            guard setupAudioEngine() else { return }
        }
        if isPlaying {
            stopPlayback()
        }
        
        do {
            player = AudioPlayer()
            mixer = Mixer()
            try player?.load(url: audioURL)
            guard let player = player, let mixer = mixer, let engine = engine else {
                throw NSError(domain: "AudioPlayerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio components"])
            }
            
            mixer.addInput(player)
            engine.output = mixer
            audioNode = mixer
            if let audioFile = try? AVAudioFile(forReading: audioURL) {
                duration = audioFile.duration
            }
            
            playbackTime = 0
            print("Audio playback setup successful for: \(audioURL.path)")
        } catch {
            alertMessage = "Could not load audio file: \(error.localizedDescription)"
            showAlert = true
            errorMessage = "Audio loading error: \(error.localizedDescription)"
        }
    }
    
    func startPlayback() {
        guard let player = player, let engine = engine else {
            setupPlayback()
            return
        }
        if !engine.avEngine.isRunning {
            do {
                try engine.start()
                isEngineRunning = true
            } catch {
                alertMessage = "Could not start audio engine: \(error.localizedDescription)"
                showAlert = true
                return
            }
        }
    
        player.play()
        isPlaying = true
        startPlaybackTimer()
        print("Started audio playback")
    }
    
    func pausePlayback() {
        guard let player = player, isPlaying else { return }
        
        player.pause()
        isPlaying = false
        stopTimer()
        print("Paused audio playback at: \(playbackTime)")
    }
    
    func stopPlayback() {
        guard let player = player else { return }
        
        player.stop()
        isPlaying = false
        playbackTime = 0
        stopTimer()
        print("Stopped audio playback")
    }
    
    private func startPlaybackTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }

            if let player = self.player {
                self.playbackTime = player.currentTime
                if self.playbackTime >= self.duration {
                    self.stopPlayback()
                }
            }
        }
    }
    
    // MARK: - Timer Functions
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.isRecording {
                self.recordingTime += 0.1
                self.duration = max(self.duration, self.recordingTime)
                if self.recordingTime >= self.MAX_RECORDING_TIME && !self.maxTimeReached {
                    self.maxTimeReached = true
                    _ = self.stopRecording()
                    
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertMessage = "Maximum recording time of 10 minutes reached."
                    }
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Utility Methods
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - File Management
    func saveRecording(as filename: String) -> URL? {
        guard let sourceURL = recordingURL, FileManager.default.fileExists(atPath: sourceURL.path) else {
            alertMessage = "Recording file not found"
            showAlert = true
            return nil
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("\(filename).aac")

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            return destinationURL
        } catch {
            errorMessage = "Failed to save recording: \(error.localizedDescription)"
            alertMessage = "Could not save your recording: \(error.localizedDescription)"
            showAlert = true
            return nil
        }
    }
    
    func cleanup() {
        if isPlaying {
            stopPlayback()
        }
        
        cleanupEngine(preserveRecording: false)
        recordingTime = 0
        playbackTime = 0
        duration = 0
        maxTimeReached = false
        player = nil
    }
    
    deinit {
        cleanup()
    }
}
