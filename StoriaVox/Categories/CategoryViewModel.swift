//
//  CategoryViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    internal func fetchCategories() {
        CategoryService.shared.getCategories { response in
            print("xxx response: \(response)")
            switch response {
            case .success(let categoriesResponse):
                self.categories = categoriesResponse.categories
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }
}
