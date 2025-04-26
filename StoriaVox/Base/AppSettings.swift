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
    @Published var currentUser: User?
    
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
