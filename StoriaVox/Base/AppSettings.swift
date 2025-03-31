//
//  AppSettings.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//
import SwiftUI
import MSAL

class AppSettings: ObservableObject {
    @Published var path = NavigationPath()
    @Published var route: Route = .unspecified
    @Published var nativeAuth: MSALNativeAuthPublicClientApplication?
    @Published var storyCategories: [Category] = [
        .init(name: "Family", icon: .init(.family)),
        .init(name: "Life Lessons", icon: .init(.lifeLessons)),
        .init(name: "Culture", icon: .init(.culture)),
        .init(name: "Childhood", icon: .init(.childhood)),
        .init(name: "Love", icon: .init(.love)),
        .init(name: "Career", icon: .init(.career)),
        .init(name: "Health", icon: .init(.health)),
        .init(name: "Travel", icon: .init(.travel)),
        .init(name: "Inspiration", icon: .init(.inspiration)),
        .init(name: "History", icon: .init(.history)),
        .init(name: "Grief", icon: .init(.grief)),
        .init(name: "Joy", icon: .init(.joy)),
        .init(name: "Fantasy", icon: .init(.fantasy)),
        .init(name: "Poetry", icon: .init(.poetry)),
        .init(name: "Dialogues", icon: .init(.dialogues)),
        .init(name: "Other", icon: .init(.other))
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
