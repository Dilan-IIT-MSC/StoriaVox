//
//  HomeNavigationHandler.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import Foundation
import SwiftUI

extension MainTabView {
    @ViewBuilder
    internal func handleHomeNavigation(route: Route) -> some View {
        switch route {
        case .unspecified:
            Text("Unspecified")
        case .home:
            Text("Unspecified")
        case .login:
            Text("Unspecified")
        case .profile:
            Text("Unspecified")
        case .signUp:
            Text("Unspecified")
        case .recording:
            Text("Unspecified")
        case .listening:
            Text("Unspecified")
        case .allCategories:
            AllCategoriesView()
                .environmentObject(appSettings)
        }
    }
}
