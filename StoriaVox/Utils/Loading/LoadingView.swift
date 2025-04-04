//
//  LoadingView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    var title: String? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 90, height: 90)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)

                    if let image = UIImage(named: AppIconProvider.appIcon()) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color.accentColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 130, height: 130)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                
                Text(title ?? "Fetching wonders...")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ProcessingIndicator: View {
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(isActive ? Color.blue : Color.gray.opacity(0.5))
                .frame(width: 10, height: 10)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(isActive ? .white : .gray)
        }
    }
}

enum AppIconProvider {
    static func appIcon(in bundle: Bundle = .main) -> String {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }

        return iconFileName
    }
}

#Preview {
    LoadingView()
}
