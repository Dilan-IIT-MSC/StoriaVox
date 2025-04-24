//
//  AppSettings.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//
import SwiftUI
import MSAL
import Combine

class AppSettings: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var profilePaths: [Route] = []
    @Published var createStoryPaths: [Route] = []
    @Published var homePaths: [Route] = []
    @Published var mainRoute: MainRoute = .unspecified
    @Published var lastRecordingURL: URL?
    @Published var storyCategories: [Category] = [
        .init(id: 1, name: "Family", description: "Stories of kinship, bonds, and unforgettable ties.", icon: 1),
        .init(id: 2, name: "Life Lessons", description: "Wisdom gained through trials, errors, and triumphs.", icon: 2),
        .init(id: 3, name: "Culture", description: "Tales rooted in tradition, heritage, and identity.", icon: 3),
        .init(id: 4, name: "Childhood", description: "Nostalgic journeys through the eyes of youth.", icon: 4),
        .init(id: 5, name: "Love", description: "Heartfelt tales of passion, connection, and romance.", icon: 5),
        .init(id: 6, name: "Career", description: "Experiences from the climb, fall, and growth at work.", icon: 6),
        .init(id: 7, name: "Health", description: "Journeys of healing, wellness, and resilience.", icon: 7),
        .init(id: 8, name: "Travel", description: "Adventures from distant lands and local gems.", icon: 8),
        .init(id: 9, name: "Inspiration", description: "Uplifting narratives that spark motivation and hope.", icon: 9),
        .init(id: 10, name: "History", description: "Echoes from the past that shaped our present.", icon: 10),
        .init(id: 11, name: "Grief", description: "Reflections on loss, mourning, and moving forward.", icon: 11),
        .init(id: 12, name: "Joy", description: "Moments of happiness, celebration, and delight.", icon: 12),
        .init(id: 13, name: "Fantasy", description: "Imaginative worlds where magic and wonder thrive.", icon: 13),
        .init(id: 14, name: "Poetry", description: "Rhythmic tales woven with emotion and depth.", icon: 14),
        .init(id: 15, name: "Dialogues", description: "Conversational stories with meaningful exchanges.", icon: 15),
        .init(id: 16, name: "Other", description: "Unique narratives beyond the usual categories.", icon: 16)
    ]
    
    init() {
        NotificationCenter.default
            .publisher(for: .showBottomBanner)
            .sink(receiveValue: { [weak self] (notification) in
                if let userInfo = notification.userInfo {
                    if let newMainRoute: MainRoute = userInfo.valueForKey("mainRoute") {
                        if self?.mainRoute != newMainRoute {
                            self?.mainRoute = newMainRoute
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
