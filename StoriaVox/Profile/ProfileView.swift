//
//  ProfileView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appSettings: AppSettings
    var body: some View {
        NavigationStack(path: $appSettings.profilePaths) {
            Text("Hello, profile world!")
        }
    }
}

#Preview {
    ProfileView().environmentObject(AppSettings())
}
