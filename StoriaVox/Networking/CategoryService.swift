//
//  CategoryService.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation
import Alamofire

class CategoryService {
    static let shared = CategoryService()
    
    private init() {}
    
    private enum Endpoints {
        static let categories = "categories"
    }
    
    func getCategories(completion: @escaping (Result<CategoriesResponse, NetworkError>) -> Void){
        NetworkService.shared.performRequest(
            endpoint: Endpoints.categories,
            method: .get,
            encoding: JSONEncoding.default,
            completion: completion
        )
    }
}
