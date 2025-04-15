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
        .init(id: 1, name: "Family", icon: .init(.family)),
        .init(id: 2, name: "Life Lessons", icon: .init(.lifeLessons)),
        .init(id: 3, name: "Culture", icon: .init(.culture)),
        .init(id: 4, name: "Childhood", icon: .init(.childhood)),
        .init(id: 5, name: "Love", icon: .init(.love)),
        .init(id: 6, name: "Career", icon: .init(.career)),
        .init(id: 7, name: "Health", icon: .init(.health)),
        .init(id: 8, name: "Travel", icon: .init(.travel)),
        .init(id: 9, name: "Inspiration", icon: .init(.inspiration)),
        .init(id: 10, name: "History", icon: .init(.history)),
        .init(id: 11, name: "Grief", icon: .init(.grief)),
        .init(id: 12, name: "Joy", icon: .init(.joy)),
        .init(id: 13, name: "Fantasy", icon: .init(.fantasy)),
        .init(id: 14, name: "Poetry", icon: .init(.poetry)),
        .init(id: 15, name: "Dialogues", icon: .init(.dialogues)),
        .init(id: 16, name: "Other", icon: .init(.other))
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
