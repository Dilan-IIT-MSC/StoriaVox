//
//  UploadingStoryView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-01.
//

import SwiftUI

struct UploadingStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appSettings: AppSettings
    @Binding var progress: Double
    @Binding var isUploaded: Bool
    var onComplete: (() -> Void)?
    @State private var navigateHome = false
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [ .accent, Color(hex: "81C784") ?? .green]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.2), value: progress)
                    
                    if !isUploaded {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.accent)
                    }
                }
                
                if isUploaded {
                    Text("Upload Complete!")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.accent)
                        .padding(.top, 20)
                        .transition(.opacity)
                } else {
                    Text("Please wait while your story uploads...")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                if isUploaded {
                    Button(action: {
                        navigateHome = true
                        onComplete?()
                    }) {
                        Text("Back to Home")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 40)
                    .transition(.opacity)
                }
            }
            .padding()
        }
        .onChange(of: navigateHome) { oldValue, newValue in
            if newValue {
                appSettings.createStoryPaths = []
            }
        }
    }
}

#Preview {
    UploadingStoryView(progress: .constant(0.5), isUploaded: .constant(false))
}
