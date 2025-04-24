//
//  APIError.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-03.
//

import Foundation
import Alamofire

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(statusCode: Int, message: String)
    case noInternetConnection
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response received from the server."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return "Server error (\(statusCode)): \(message)"
        case .noInternetConnection:
            return "No internet connection available."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

enum NetworkError: Error {
    case networkError(AFError)
    case serverMessage(String)
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverMessage(let message):
            return message
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
