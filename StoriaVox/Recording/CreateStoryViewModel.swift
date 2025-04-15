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
        // Clean up any existing engine first
        cleanupEngine()
        
        // Set up audio session
        guard setupAudioSession() else { return false }
        
        do {
            // Create a new engine
            engine = AudioEngine()
            guard let engine = engine else { return false }
            
            // Get the input (microphone)
            guard let input = engine.input else {
                errorMessage = "Could not access microphone input"
                alertMessage = "Microphone not available. Please check your device settings."
                showAlert = true
                return false
            }
            
            // Make input available for FFT visualization
            audioNode = input
            
            // Create a mixer
            mixer = Mixer(input)
            
            // Set the engine's output to the mixer
            engine.output = mixer
            
            // Start the engine
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
        // Only attempt to start if not already running
        if !isEngineRunning {
            _ = setupAudioEngine()
        }
    }
    
    func stopEngine() {
        // Don't call cleanupEngine() here as it might delete our recording
        // Instead, manually stop the engine without releasing resources
        
        // Stop timer
        stopTimer()
        
        // Stop recording if in progress
        if isRecording {
            _ = stopRecording()
        }
        
        // Stop playback if in progress
        if isPlaying {
            stopPlayback()
        }
        
        // Stop the engine
        engine?.stop()
        
        // Update state
        isEngineRunning = false
    }
    
    private func cleanupEngine(preserveRecording: Bool = true) {
        // Stop timer
        stopTimer()
        
        // If recording is in progress, stop it first
        if isRecording || isPaused {
            _ = stopRecording()
        }
        
        // If playback is in progress, stop it
        if isPlaying {
            stopPlayback()
        }
        
        // If we need to preserve the recording, don't release the recorder yet
        if !preserveRecording {
            recorder = nil
        }
        
        // Stop engine
        engine?.stop()
        engine = nil
        
        // Reset player, mixer and node references
        player = nil
        mixer = nil
        audioNode = nil
        
        // Update state
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
        // If we're already recording, do nothing
        guard !isRecording else { return }
        
        // Ensure audio engine is running
        if !isEngineRunning {
            guard setupAudioEngine() else { return }
        }
        
        // Make sure we have a mixer
        guard let mixer = self.mixer else {
            alertMessage = "Audio system not ready. Please try again."
            showAlert = true
            return
        }
        
        // If we're not resuming from pause, create a new recording
        if !isPaused {
            // Create a directory for our recordings if needed
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let recordingsDirectory = documentsPath.appendingPathComponent("Recordings", isDirectory: true)
            
            do {
                if !FileManager.default.fileExists(atPath: recordingsDirectory.path) {
                    try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true)
                }
            } catch {
                print("Could not create recordings directory: \(error.localizedDescription)")
            }
            
            // Make sure the old recorder is stopped but don't release it
            // to ensure we don't lose the previous recording
            if isRecording {
                recorder?.stop()
            }
            
            // Reset timers and state
            recordingTime = 0
            duration = 0
            maxTimeReached = false
            
            // Create a new recorder
            do {
                // Set shouldCleanupRecordings to false to prevent automatic cleanup
                recorder = try NodeRecorder(node: mixer,
                                          fileDirectoryURL: recordingsDirectory,
                                          shouldCleanupRecordings: false)
            } catch {
                alertMessage = "Could not create recorder: \(error.localizedDescription)"
                showAlert = true
                return
            }
        }
        
        // Start recording
        do {
            try recorder?.record()
            isRecording = true
            isPaused = false
            
            // Start timer
            startTimer()
        } catch {
            alertMessage = "Could not start recording: \(error.localizedDescription)"
            showAlert = true
            errorMessage = "Recording error: \(error.localizedDescription)"
        }
    }
    
    func pauseRecording() {
        guard isRecording, !isPaused, let recorder = recorder else { return }
        
        // Stop the recording but keep the recorder
        recorder.stop()
        
        // Get the file URL and save it (important - do this before releasing the recorder)
        if let audioFile = recorder.audioFile {
            recordingURL = audioFile.url
            print("Recording paused, file saved at: \(audioFile.url.path)")
        }
        
        // Update state
        isPaused = true
        isRecording = false
        
        // Stop the timer
        stopTimer()
        
        // Update duration
        duration = max(duration, recordingTime)
    }
    
    func stopRecording() -> URL? {
        guard let recorder = recorder else { return nil }
        
        // Stop recording
        recorder.stop()
        
        // Get the file URL and save it before releasing the recorder
        if let audioFile = recorder.audioFile {
            recordingURL = audioFile.url
            print("Recording stopped, file saved at: \(audioFile.url.path)")
            
            // Explicitly save the file to a permanent location
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let timestamp = Int(Date().timeIntervalSince1970)
            let permanentURL = documentsPath.appendingPathComponent("recording_\(timestamp).aac")
            
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
        
        // Update state
        isRecording = false
        isPaused = false
        
        // Stop timer
        stopTimer()
        
        // Update duration
        duration = max(duration, recordingTime)
        
        // Don't release the recorder yet to prevent file cleanup
        // We'll manually release it when we're done with the file
        
        // Return the recording URL
        return recordingURL
    }
    
    // MARK: - Audio Playback Methods
    func setupPlayback(for url: URL? = nil) {
        // Use the provided URL or fall back to recordingURL
        guard let audioURL = url ?? recordingURL else {
            alertMessage = "No audio recording available"
            showAlert = true
            return
        }
        
        // Ensure engine is running
        if !isEngineRunning {
            guard setupAudioEngine() else { return }
        }
        
        // Stop any existing playback
        if isPlaying {
            stopPlayback()
        }
        
        do {
            // Create a new player and mixer for playback
            player = AudioPlayer()
            mixer = Mixer()
            
            // Load the audio file into the player
            try player?.load(url: audioURL)
            
            // Make sure we have valid objects
            guard let player = player, let mixer = mixer, let engine = engine else {
                throw NSError(domain: "AudioPlayerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio components"])
            }
            
            // Connect player to mixer
            mixer.addInput(player)
            
            // Connect mixer to engine output
            engine.output = mixer
            
            // Make mixer available for FFT visualization
            audioNode = mixer
            
            // Update duration if possible
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
        
        // Make sure engine is running
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
        
        // Start playback
        player.play()
        isPlaying = true
        
        // Start timer to track playback time
        startPlaybackTimer()
        
        print("Started audio playback")
    }
    
    func pausePlayback() {
        guard let player = player, isPlaying else { return }
        
        player.pause()
        isPlaying = false
        
        // Stop timer
        stopTimer()
        
        print("Paused audio playback at: \(playbackTime)")
    }
    
    func stopPlayback() {
        guard let player = player else { return }
        
        player.stop()
        isPlaying = false
        playbackTime = 0
        
        // Stop timer
        stopTimer()
        
        print("Stopped audio playback")
    }
    
    private func startPlaybackTimer() {
        // Stop any existing timer first
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            
            // Update playback time
            if let player = self.player {
                self.playbackTime = player.currentTime
                
                // Check if playback has ended
                if self.playbackTime >= self.duration {
                    self.stopPlayback()
                }
            }
        }
    }
    
    // MARK: - Timer Functions
    private func startTimer() {
        // Stop any existing timer first
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.isRecording {
                self.recordingTime += 0.1
                self.duration = max(self.duration, self.recordingTime)
                
                // Check if max recording time reached
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
        
        // Copy the file
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
    
    // MARK: - Cleanup
    func cleanup() {
        // Stop playback if in progress
        if isPlaying {
            stopPlayback()
        }
        
        // Call the clean with preserveRecording=false to fully release all resources
        cleanupEngine(preserveRecording: false)
        
        // Reset state
        recordingTime = 0
        playbackTime = 0
        duration = 0
        maxTimeReached = false
        player = nil
        
        // We're keeping recordingURL as it might be needed
    }
    
    deinit {
        cleanup()
    }
}
