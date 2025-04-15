//
//  CreateStoryViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-13.
//

import SwiftUI
import AudioKit
import AVFoundation

class CreateStoryViewModel: ObservableObject {
    // MARK: - Constants
    private let MAX_RECORDING_TIME: TimeInterval = 600 // 10 minutes in seconds
    
    // MARK: - Audio Engine Properties
    let engine = AudioEngine()
    private var mic: AudioEngine.InputNode?
    private var mixer: Mixer?
    private var recorder: NodeRecorder?
    private var timer: Timer?
    var recordingURL: URL?
    
    // MARK: - Published Properties
    @Published var isRecording = false
    @Published var isPaused = false
    @Published var recordingTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var errorMessage: String?
    @Published var maxTimeReached = false
    
    // MARK: - Initialization
    init() {
        setupAudioSession()
        setupAudioEngine()
    }
    
    // MARK: - Audio Setup
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            errorMessage = "Failed to set up audio session: \(error.localizedDescription)"
        }
    }
    
    private func setupAudioEngine() {
        guard let mic = engine.input else {
            return
        }
        mixer = Mixer(mic)
        
        // Set the engine's output to the mixer
        engine.output = mixer
        
        // Create a temporary URL for recording
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordingURL = documentsPath.appendingPathComponent("tempRecording.aac")
        
        // Initialize the recorder
        if let url = recordingURL, let mixer = mixer {
            do {
                recorder = try NodeRecorder(node: mixer, fileDirectoryURL: url)
            } catch {
                errorMessage = "Could not initialize recorder: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Engine Control
    func startEngine() {
        do {
            try engine.start()
        } catch {
            errorMessage = "Could not start engine: \(error.localizedDescription)"
        }
    }
    
    func stopEngine() {
        engine.stop()
    }
    
    // MARK: - Recording Methods
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func startRecording() {
        guard let recorder = recorder, !isRecording else { return }
        
        // If we're resuming from pause, don't reset the recording
        if !isPaused {
            // Create a new recording file
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let timestamp = Int(Date().timeIntervalSince1970)
            recordingURL = documentsPath.appendingPathComponent("recording_\(timestamp).aac")
            
            // Reset the recorder with the new URL
            if let url = recordingURL, let mixer = mixer {
                do {
                    self.recorder = try NodeRecorder(node: mixer, fileDirectoryURL: url)
                } catch {
                    errorMessage = "Could not initialize recorder: \(error.localizedDescription)"
                    return
                }
            }
            
            // Reset the timer and max time flag
            recordingTime = 0
            duration = 0
            maxTimeReached = false
        }
        
        do {
            try recorder.record()
            isRecording = true
            isPaused = false
            
            // Start or resume the timer
            startTimer()
        } catch {
            errorMessage = "Could not record: \(error.localizedDescription)"
        }
    }
    
    func pauseRecording() {
        guard let recorder = recorder, isRecording, !isPaused else { return }
        
        recorder.stop()
        isPaused = true
        isRecording = false
        
        // Stop the timer
        stopTimer()
        
        // Update duration
        duration = max(duration, recordingTime)
    }
    
    func stopRecording() -> URL? {
        guard let recorder = recorder else { return nil }
        
        recorder.stop()
        isRecording = false
        isPaused = false
        
        // Stop the timer
        stopTimer()
        
        // Update duration
        duration = max(duration, recordingTime)
        
        // Return the URL of the recorded file
        return recordingURL
    }
    
    // MARK: - Timer Functions
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.isRecording {
                self.recordingTime += 0.1
                self.duration = max(self.duration, self.recordingTime)
                
                // Check if max recording time reached
                if self.recordingTime >= self.MAX_RECORDING_TIME && !self.maxTimeReached {
                    self.maxTimeReached = true
                    self.stopRecording()
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
        guard let sourceURL = recordingURL else { return nil }
        
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
            return nil
        }
    }
    
    // MARK: - Cleanup
    func cleanup() {
        recorder?.stop()
        engine.stop()
        
        stopTimer()
        
        // Reset state
        isRecording = false
        isPaused = false
        recordingTime = 0
        duration = 0
        maxTimeReached = false
    }
}
