//
//  AddMetaDataView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import SwiftUI

struct AddMetaDataView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var viewModel: MetaDataViewModel
    @State var chipViewHeight: CGFloat = .zero
    @State var storyTitle: String = ""
    @State var storyTitleError: String? = nil
    
    // Colors for visualization
    private let activeVisualizerColor = Color.green
    private let inactiveVisualizerColor = Color.gray.opacity(0.3)
    
    // Initialize with audio URL
    init(audioURL: URL) {
        _viewModel = StateObject(wrappedValue: MetaDataViewModel(audioURL: audioURL))
    }
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.whiteBackground)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                            .frame(height: 240)
                        
                        VStack {
                            Text("Preview Your Story")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.top, 16)
                            
                            Text("Duration: \(viewModel.formatTime(viewModel.duration))")
                                .font(.subheadline)
                                .foregroundColor(.secondary.opacity(0.8))
                                .padding(.bottom, 8)
                            
                            AudioVisualisationView(
                                amplitudes: viewModel.amplitudes,
                                isPlaying: viewModel.isPlaying,
                                activeColor: activeVisualizerColor,
                                inactiveColor: inactiveVisualizerColor
                            )
                            
                            // Playback controls
                            HStack(spacing: 0) {
                                VStack(spacing: 6) {
                                    AudioProgressBar(
                                        value: viewModel.duration > 0 ? min(viewModel.playbackTime / viewModel.duration, 1.0) : 0
                                    )
                                    .frame(height: 6)
                                    
                                    HStack {
                                        Text(viewModel.formatTime(viewModel.playbackTime))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Text(viewModel.formatTime(viewModel.duration))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                
                                Spacer()
                                
                                Button {
                                    if viewModel.isPlaying {
                                        viewModel.pausePlayback()
                                    } else {
                                        viewModel.startPlayback()
                                    }
                                } label: {
                                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .padding(14)
                                        .background(Circle().fill(Color.accentColor))
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                            .padding(.horizontal, 16)
                            
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack(spacing: 4) {
                            Text("Complete Your Story")
                                .font(.system(size: 20, weight: .medium))
                            
                            Spacer()
                        }
                        .padding(.bottom, 24)
                        
                        HStack(spacing: 4) {
                            Text("Give your story a title")
                                .font(.system(size: 16, weight: .medium))
                            
                            Spacer()
                        }
                        
                        CustomTextField(placeholder: "Title", text: $storyTitle, errorMessage: $storyTitleError)
                        
                        Divider()
                            .background(.border)
                            .padding(.top, 24)
                        
                        // MARK: Category Selection
                        Section {
                            HStack(spacing: 4) {
                                Text("What's your story about?")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("(Choose up to 3)")
                                    .font(.system(size: 14, weight: .light))
                                    .italic()
                                
                                Spacer()
                            }
                            
                            VStack {
                                var width = CGFloat.zero
                                var height = CGFloat.zero
                                GeometryReader { geo in
                                    ZStack(alignment: .topLeading, content: {
                                        ForEach(0..<appSettings.storyCategories.count, id: \.self) { index in
                                            CategoryChipView(
                                                selectedCategories: $viewModel.selectedCategories,
                                                category: appSettings.storyCategories[index]
                                            )
                                                .padding(.all, 5)
                                                .alignmentGuide(.leading) { dimension in
                                                    if (abs(width - dimension.width) > geo.size.width) {
                                                        width = 0
                                                        height -= dimension.height
                                                    }
                                                    let result = width
                                                    if index == appSettings.storyCategories.count - 1 {
                                                        width = 0
                                                    } else {
                                                        width -= dimension.width
                                                    }
                                                    return result
                                                }
                                                .alignmentGuide(.top) { dimension in
                                                    let result = height
                                                    if index == appSettings.storyCategories.count - 1 {
                                                        height = 0
                                                    }
                                                    return result
                                                }
                                        }
                                    })
                                    .padding(.top, 12)
                                    .readSize { size in
                                        chipViewHeight = size.height
                                    }
                                }
                            }
                            .frame(height: chipViewHeight + 12)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Divider()
                    .background(.border)
                
                HStack {
                    Spacer()
                    
                    Button {
                        saveStory(asDraft: true)
                    } label: {
                        Text("Save Draft")
                            .foregroundStyle(.accent)
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(width: 150, alignment: .center)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            }
                    }
                    
                    Spacer()
                    
                    Button {
                        saveStory(asDraft: false)
                    } label: {
                        Text("Publish")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(width: 150, alignment: .center)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("Story Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Notice"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func saveStory(asDraft: Bool) {
        if storyTitle.isEmpty {
            storyTitleError = "Please enter a title for your story"
            return
        }
        viewModel.alertMessage = asDraft
            ? "Story saved as draft successfully!"
            : "Story published successfully!"
        viewModel.showAlert = true
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    let previewURL = URL(fileURLWithPath: "/tmp/audio.aac")
    return AddMetaDataView(audioURL: previewURL).environmentObject(AppSettings())
}
