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
        if let user = UserDefaultsManager.shared.loggedInUser {
            DashboardService.shared.fetchDashboard(userId: user.id) { [weak self] response in
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
    
    internal func fetchCategories() {
        CategoryService.shared.getCategories { [weak self] response in
            switch response {
            case .success(let categoriesResponse):
                UserDefaultsManager.shared.savedCategories = categoriesResponse.categories.map({ $0.category })
                self?.getDashboardData()
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
    
    internal func fetchUser() {
        guard let userEmail = UserDefaultsManager.shared.loggedInUserEmail else {
            return
        }
        
        UserService.shared.getUserByEmail(email: userEmail.lowercased()) { [weak self] response in
            switch response {
            case .success(let userData):
                UserDefaultsManager.shared.loggedInUser = userData?.user
                self?.fetchCategories()
            case .failure(let error):
                print(#function, "Failed to fetch user \(error.localizedDescription)")
            }
        }
    }
}
