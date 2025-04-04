//
//  AppSettings.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//
import SwiftUI
import MSAL

class AppSettings: ObservableObject {
    @Published var profilePaths: [Route] = []
    @Published var createStoryPaths: [Route] = []
    @Published var homePaths: [Route] = []
    @Published var mainRoute: MainRoute = .unspecified
    @Published var nativeAuth: MSALNativeAuthPublicClientApplication?
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
        do {
            self.nativeAuth = try MSALNativeAuthPublicClientApplication(
                clientId: "f33cf369-7f6a-4c45-b005-e739e3ecb4ea",
                tenantSubdomain: "storiavoxapp",
                challengeTypes: [.OOB, .password]
            )
            
            print("Initialized Native Auth successfully.")
        } catch {
            print("Unable to initialize MSAL: \(error)")
        }
    }
}
