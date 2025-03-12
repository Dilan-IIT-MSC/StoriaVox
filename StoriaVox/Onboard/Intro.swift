//
//  Intro.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-12.
//

import Foundation
import SwiftUICore

struct Intro: Identifiable {
    var id: String = UUID().uuidString
    var image: Image
    var title: String
    var description: String
}

internal let intros: [Intro] = [
    .init(image: .init(.onboard1),
          title: "Welcome to StoriaVox",
          description: "Share your stories across generations with our AI-enhanced storytelling app. Preserve memories, connect with loved ones, and create lasting bonds through the power of personal narratives."),
    .init(image: .init(.onboard2),
          title: "Capture Your Voice, Share Your Journey",
          description: "Record your stories with ease using our intuitive audio recording tools. Our app helps you preserve important memories and life experiences through high-quality voice recordings that can be shared with family members of all ages."),
    .init(image: .init(.onboard3),
          title: "Stories Enhanced by AI",
          description: "Experience your stories in a new way with our Azure AI technology. We analyze emotional tones and generate custom background music that matches the sentiment of your narrative, creating an immersive multi-sensory experience."),
    .init(image: .init(.onboard4),
          title: "Bridge Generations, Preserve Memories",
          description: "Designed for users of all ages and tech abilities, our app brings families closer together. With accessibility features like customizable text sizes, voice commands, and high-contrast options, everyone can participate in sharing and experiencing meaningful stories.")
]
