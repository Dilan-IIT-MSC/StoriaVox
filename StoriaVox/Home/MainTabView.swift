//
//  MainTabView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTabIndex = 0
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            DiscoverView()
                .tag(0)
                .tabItem {
                    Text("Discover")
                    Image(systemName: "house")
                }
            
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
    }
}

#Preview {
    MainTabView()
}
