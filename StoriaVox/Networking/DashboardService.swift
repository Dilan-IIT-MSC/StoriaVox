//
//  DashboardService.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import Alamofire

class DashboardService {
    static let shared = DashboardService()
    
    private init() {}
    
    private enum Endpoints {
        static let dashboard = "dashboard"
    }
    
    func fetchDashboard(
        userId: Int,
        completion: @escaping (Result<DashboardResponse, NetworkError>) -> Void
    ) {
        var parameters: [String: Any] = ["user_id": userId]
        
        NetworkService.shared.performRequest(
            endpoint: Endpoints.dashboard,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            completion: completion
        )
    }
}
