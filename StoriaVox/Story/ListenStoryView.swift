//
//  ListenStoryView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-30.
//

import SwiftUI
import AudioKit

struct ListenStoryView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var isPlaying: Bool = false
    @State private var currentTime: TimeInterval = 1
    @State private var totalDuration: TimeInterval = 200
    @State private var audioAmplitudes: [CGFloat] = Array(repeating: 0, count: 30)
    let story: StoryListItem
    
    let podcastTitle = "How to design Beautiful Mindset in our life"
    let author = "Tracy Clayton"
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color(hex: "#E0F182") ?? .accent)
                .ignoresSafeArea()
   
            VStack(spacing: 0) {
                ZStack {
                    if let url = story.thumbnailUrl {
                        AsyncImage(url: URL(string: url)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.backgroundColors.randomElement() ?? .gray
                        }
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Button(action: {}) {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundColor(.black)
                                        )
                                }
                                
                                Button(action: {}) {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "heart.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.red)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, safeAreaInsets.top)
                        
                        Spacer()
                    }
                    
                }
                
                
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(story.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(hex: "#1A2B40"))
                            .lineLimit(2)
                        
                        Text(story.author.displayTitle)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#666666"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 24)
                    .padding(.top, 36)
                    
                    AudioVisualisationView()
                        .frame(height: 60)
                        .onReceive(timer) { _ in
                            updateAmplitudes()
                        }
                    
                    HStack {
                        Text(formatTime(currentTime))
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#666666"))
                        
                        Spacer()
                        
                        Text(formatTime(totalDuration))
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#666666"))
                    }
                    .padding(.top, 8)
                    
                    // Playback controls
                    HStack(spacing: 32) {
                        Button(action: {
                            currentTime = max(0, currentTime - 10)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "gobackward.10")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            isPlaying.toggle()
                        }) {
                            Circle()
                                .fill(Color(hex: "#1A2B40") ?? .green)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        Button(action: {
                            currentTime = min(totalDuration, currentTime + 10)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "goforward.10")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.vertical, 24)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, safeAreaInsets.bottom + 30)
                .background(Color.background)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .onAppear {
            isPlaying = true
            startPlaybackSimulation()
        }
        .ignoresSafeArea()
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateAmplitudes() {
        audioAmplitudes = audioAmplitudes.map { _ in
            CGFloat.random(in: 0.05...1.0)
        }
    }
    
    private func startPlaybackSimulation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if isPlaying {
                currentTime += 1
                if currentTime >= totalDuration {
                    currentTime = 0
                }
            }
        }
    }
}

struct AudioKitManager {
    static func setupAudioKit() {
    }
    
    static func getFFTData() -> [CGFloat] {
        return Array(repeating: 0, count: 30)
    }
}
