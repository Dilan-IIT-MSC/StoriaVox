//
//  DiscoverViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

class DiscoverViewModel: ObservableObject {
    @Published var dashboardData: Dashboard?
    
    internal func getDashboardData() {
        if let userId = UserDefaultsManager.shared.loggedInUserId {
            DashboardService.shared.fetchDashboard(userId: Int(userId) ?? 0) { [weak self] response in
                switch response {
                case .success(let dashboardData):
                    self?.dashboardData = dashboardData.dashboard
                    BannerHandler.shared.showSuccessBanner(title: "Success", message: "Dashboard fetched successfully.", isAutoHide: true)
                case .failure(let error):
                    BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
                }
            }
        }
    }
}
