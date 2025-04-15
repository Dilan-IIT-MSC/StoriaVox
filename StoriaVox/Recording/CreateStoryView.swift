//
//  CreateStoryView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI
import AVFoundation
import AudioKit

struct CreateStoryView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var viewModel = CreateStoryViewModel()
    @State private var recordingURL: URL?
    @State private var showDiscardAlert = false
    @State private var animateVisualizer = false
    @State private var showStatusIndicator = false
    
    // Colors
    private let visualizerColor = Color(red: 86/255, green: 210/255, blue: 190/255)
    private let cardBackground = Color(white: 0.98)
    
    var body: some View {
        NavigationStack(path: $appSettings.createStoryPaths) {
            ZStack {
                Color.background
                
                VStack(spacing: 0) {
                    
                    // Recording status indicator
                    if showStatusIndicator {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(viewModel.isRecording ? Color.red : Color.orange)
                                .frame(width: 8, height: 8)
                            
                            Text(viewModel.isRecording ? "Recording" : viewModel.isPaused ? "Paused" : "")
                                .font(.subheadline)
                                .foregroundColor(viewModel.isRecording ? .red : .orange)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                        .padding(.bottom, 8)
                    }
                    
                    // Main visualizer card
                    VStack(spacing: 20) {
                        ZStack {
                            if viewModel.isRecording || viewModel.isPaused {
                                Circle()
                                    .fill(Color.whiteBackground)
                                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                                    .frame(width: 340, height: 340)
                                
                                if let mic = viewModel.engine?.input {
                                    FFTView(
                                        mic,
                                        barColor: visualizerColor,
                                        paddingFraction: 0.05,
                                        placeMiddle: false,
                                        barCount: 120,
                                        maxAmplitude: -10,
                                        minAmplitude: -130
                                    )
                                    .frame(width: 340, height: 340)
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(animateVisualizer ? 1.02 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true),
                                        value: animateVisualizer
                                    )
                                    .overlay(
                                        ZStack {
                                            Circle()
                                                .fill(Color.accentColor)
                                                .frame(width: 180, height: 180)
                                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
                                            
                                            Text(viewModel.formatTime(viewModel.recordingTime))
                                                .font(.system(size: 48, weight: .medium))
                                                .foregroundStyle(Color.white.opacity(0.8))
                                                .fontDesign(.rounded)
                                        }
                                    )
                                }
                            } else {
                                Circle()
                                    .fill(Color.whiteBackground)
                                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                                    .frame(width: 340, height: 340)
                                    .overlay(
                                        VStack(spacing: 16) {
                                            Image(systemName: "mic.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 70, height: 70)
                                                .foregroundColor(.accentColor)
                                                .opacity(0.8)
                                                .padding(.top, 20)
                                            
                                            Text("Tap Record to Start")
                                                .font(.headline)
                                                .foregroundColor(.secondary)
                                        }
                                    )
                                    .onTapGesture {
                                        requestMicrophonePermission()
                                    }
                            }
                        }
                        .frame(width: 340, height: 340)
                        .padding(.top, 20)
                        
                        if viewModel.isRecording || viewModel.isPaused || viewModel.duration > 0 {
                            VStack(spacing: 10) {
                                AudioProgressBar(value: min(viewModel.recordingTime / 600, 1.0))
                                    .frame(height: 8)
                                
                                HStack {
                                    Text(viewModel.formatTime(viewModel.recordingTime))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Text("Max: 10:00")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(height: 70)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.whiteBackground)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
                            )
                            .padding(.horizontal, 16)
                        } else {
                            VStack(spacing: 6) {
                                Text("Record your amazing story")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text("Maximum 10 minutes")
                                    .font(.caption)
                                    .foregroundColor(.secondary.opacity(0.7))
                            }
                            .frame(height: 70)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.whiteBackground)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
                            )
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer()

                        HStack(spacing: 0) {
                            VStack(spacing: 8) {
                                Button {
                                    if viewModel.isRecording {
                                        pauseRecording()
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(viewModel.isRecording ? visualizerColor : Color.gray.opacity(0.2))
                                            .frame(width: 64, height: 64)
                                            .shadow(color: viewModel.isRecording ? visualizerColor.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                                        
                                        Image(systemName: "pause.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                    }
                                }
                                .buttonStyle(ScaleButtonStyle())
                                .disabled(!viewModel.isRecording)
                                
                                Text("Pause")
                                    .font(.caption)
                                    .foregroundColor(viewModel.isRecording ? .primary : .gray)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 8) {
                                Button {
                                    if !viewModel.isRecording {
                                        if viewModel.isPaused {
                                            resumeRecording()
                                        } else {
                                            startRecording()
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(!viewModel.isRecording ? Color.red : Color.gray.opacity(0.2))
                                            .frame(width: 74, height: 74)
                                            .shadow(color: !viewModel.isRecording ? Color.red.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 68, height: 68)
                                        
                                        Circle()
                                            .fill(!viewModel.isRecording ? Color.red : Color.gray.opacity(0.2))
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                .buttonStyle(ScaleButtonStyle())
                                .disabled(viewModel.isRecording)
                                
                                Text(viewModel.isPaused ? "Resume" : "Record")
                                    .font(.caption)
                                    .foregroundColor(!viewModel.isRecording ? .primary : .gray)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 8) {
                                Button {
                                    stopRecording()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.isRecording || viewModel.isPaused ? visualizerColor : Color.gray.opacity(0.2))
                                            .frame(width: 60, height: 60)
                                            .shadow(color: (viewModel.isRecording || viewModel.isPaused) ? visualizerColor.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.white)
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .buttonStyle(ScaleButtonStyle())
                                .disabled(!viewModel.isRecording && !viewModel.isPaused)
                                
                                Text("Stop")
                                    .font(.caption)
                                    .foregroundColor(viewModel.isRecording || viewModel.isPaused ? .primary : .gray)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 60)
                        .padding(.horizontal, 16)
                        .background(Color.whiteBackground)
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                    }
                }
                .padding(.top, safeAreaInsets.top)
                .padding(.bottom, safeAreaInsets.bottom)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let url = recordingURL {
                            let timestamp = Int(Date().timeIntervalSince1970)
                            if let savedURL = viewModel.saveRecording(as: "story_\(timestamp)") {
                                appSettings.lastRecordingURL = savedURL
                                appSettings.createStoryPaths.append(.storyMetadata)
                            } else {
                                viewModel.showAlert = true
                                viewModel.alertMessage = "Failed to save the recording"
                            }
                        } else {
                            viewModel.showAlert = true
                            viewModel.alertMessage = "Please record a story first"
                        }
                    } label: {
                        Text("Next")
                            .fontWeight(.medium)
                            .foregroundColor(recordingURL != nil ? visualizerColor : Color.gray.opacity(0.5))
                    }
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    if viewModel.isRecording || viewModel.isPaused || viewModel.duration > 0 {
                        Button(action: {
                            if viewModel.isRecording || viewModel.isPaused || viewModel.duration > 0 {
                                showDiscardAlert = true
                            }
                        }) {
                            Image(systemName: "arrow.uturn.backward.circle")
                                .font(.system(size: 22))
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    
                }
            }
            .ignoresSafeArea(.all)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .storyMetadata:
                    AddMetaDataView(audioURL: appSettings.lastRecordingURL!)
                default: EmptyView()
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Notice"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert("Discard Recording?", isPresented: $showDiscardAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    viewModel.cleanup()
                    recordingURL = nil
                    viewModel.stopEngine()
                    viewModel.startEngine()
                }
            } message: {
                Text("This will delete your current recording. This action cannot be undone.")
            }
            .onAppear {
                viewModel.startEngine()
                animateVisualizer = true
            }
            .onChange(of: viewModel.isRecording || viewModel.isPaused, { oldValue, newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    showStatusIndicator = newValue
                }
            })
            .onDisappear {
                viewModel.cleanup()
                viewModel.stopEngine()
            }
        }
    }
    
    // Request microphone permission before recording
    private func requestMicrophonePermission() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        
        viewModel.requestMicrophonePermission { granted in
            if granted {
                generator.impactOccurred()
                startRecording()
            } else {
                viewModel.showAlert = true
                viewModel.alertMessage = "Microphone access is required to record stories. Please enable it in Settings."
            }
        }
    }
    
    private func startRecording() {
        viewModel.startRecording()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func resumeRecording() {
        viewModel.startRecording()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func pauseRecording() {
        viewModel.pauseRecording()
        recordingURL = viewModel.recordingURL
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func stopRecording() {
        recordingURL = viewModel.stopRecording()
        if recordingURL == nil {
            viewModel.showAlert = true
            viewModel.alertMessage = "Failed to save the recording"
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    CreateStoryView().environmentObject(AppSettings())
}
