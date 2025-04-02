//
//  CreateStoryView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct CreateStoryView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var isRecording: Bool = true
    
    var body: some View {
        NavigationStack(path: $appSettings.createStoryPaths) {
            ZStack {
                Color.background
                
                VStack {
                    ZStack {
                        if isRecording {
                            Text("03:23")
                                .font(.system(size: 48))
                                .foregroundStyle(.accent)
                                .fontDesign(.rounded)
                        } else {
                            Image(systemName: "microphone.fill")
                                .resizable()
                                .frame(width: 100, height: 150)
                                .foregroundColor(.accentColor)
                                .onTapGesture {
                                    isRecording.toggle()
                                }
                        }
                        
                        Circle()
                            .stroke(Color.accentColor, lineWidth: 4)
                            .frame(width: 250, height: 250)
                    }
                    .frame(width: 300, height: 300)
                    
                    Spacer()
                    
                    AudioVisualisationView()
                        .padding()
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "play.fill")
                            .resizable()
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .frame(width: 50, height: 50)
                            .shadow(radius: 1)
                        
                        Spacer()
                        
                        if isRecording {
                            Image(systemName: "pause.circle")
                                .resizable()
                                .foregroundStyle(.errorBackground)
                                .frame(width: 50, height: 50)
                                .shadow(radius: 1)
                        } else {
                            Image(systemName: "record.circle")
                                .resizable()
                                .foregroundStyle(.errorBackground)
                                .frame(width: 50, height: 50)
                                .shadow(radius: 1)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "stop.fill")
                            .resizable()
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .frame(width: 50, height: 50)
                            .shadow(radius: 1)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 100 + safeAreaInsets.top)
                .padding(.bottom, safeAreaInsets.bottom + 100)
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        appSettings.createStoryPaths.append(.storyMetadata)
                    } label: {
                        Text("Next")
                    }
                    
                }
            }
            .ignoresSafeArea(.all)
            .navigationDestination(for: Route.self) { route in
                
            }
        }
    }
}

#Preview {
    CreateStoryView().environmentObject(AppSettings())
}
