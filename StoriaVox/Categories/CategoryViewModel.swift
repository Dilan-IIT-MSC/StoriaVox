//
//  CategoryViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [CategoryData] = []
    
    internal func fetchCategories() {
        CategoryService.shared.getCategories { response in
            switch response {
            case .success(let categoriesResponse):
                self.categories = categoriesResponse.categories
                BannerHandler.shared.showSuccessBanner(title: "Success", message: "Categories fetched successfully.", isAutoHide: true)
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
}
