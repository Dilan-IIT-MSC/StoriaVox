//
//  MainTabView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State private var selectedTabIndex = 0
    
    var body: some View {
        NavigationStack(path: $appSettings.path) {
            TabView(selection: $selectedTabIndex) {
                DiscoverView()
                    .tag(0)
                    .tabItem {
                        Text("Discover")
                        Image(systemName: "house")
                    }
                    .environmentObject(appSettings)
                
                CreateStoryView()
                    .tag(1)
                    .tabItem {
                        Text("Create")
                        Image(systemName: "waveform.badge.microphone")
                    }
                
                ProfileView()
                    .tag(2)
                    .tabItem {
                        Text("Profile")
                        Image(systemName: "person.circle")
                    }
            }
            .tabViewStyle(.automatic)
            .environment(\.horizontalSizeClass, .compact)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                handleHomeNavigation(route: route)
            }
        }
    }
}

#Preview {
    MainTabView().environmentObject(AppSettings())
}
