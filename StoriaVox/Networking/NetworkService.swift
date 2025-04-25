//
//  NetworkService.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private enum BaseURL {
        static let development = "https://storiavoxfunctionapp.azurewebsites.net/api"
        static let production = ""
    }
    
    private enum FunctionKeys {
        static let development = "m1BXk7d_l6PMDFtdoYZgrN2qV9IadoXF-b99dWLJhyz-AzFuATmkKA=="
        static let production = ""
    }
    
    private let baseURL: String
    private let functionKey: String
    
    private init() {
        self.baseURL = BaseURL.development
        self.functionKey = FunctionKeys.development
    }
    
    func buildURL(endpoint: String) -> String {
        return "\(baseURL)/\(endpoint)"
    }
    
    private func addAuthHeaders(to headers: HTTPHeaders?, authType: AuthType = .function) -> HTTPHeaders {
        var updatedHeaders = headers ?? HTTPHeaders()
        
        switch authType {
        case .function:
            updatedHeaders.add(name: "x-functions-key", value: functionKey)
        case .master:
            updatedHeaders.add(name: "x-functions-key", value: "")
        case .none:
            break
        }
        
        return updatedHeaders
    }
    
    // MARK: - Authentication Types
    enum AuthType {
        case function
        case master
        case none
    }
    
    @discardableResult
    func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding? = nil,
        headers: HTTPHeaders? = nil,
        authType: AuthType = .function,
        keyPath: String? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> DataRequest {
        let url = buildURL(endpoint: endpoint)
        let finalHeaders = addAuthHeaders(to: headers, authType: authType)
        
        let finalEncoding: ParameterEncoding = encoding ?? (method == .get || method == .delete ? URLEncoding.default : JSONEncoding.default)
        
        let request = AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: finalEncoding,
            headers: finalHeaders
        ).validate()
        
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let keyPath = keyPath {
                        // Decode from a specific keyPath if provided
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let nestedData = json[keyPath] {
                            let nestedDataJson = try JSONSerialization.data(withJSONObject: nestedData)
                            let decoded = try JSONDecoder().decode(T.self, from: nestedDataJson)
                            completion(.success(decoded))
                        } else {
                            // Try to check if there's an error message before failing
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let status = json["status"] as? Bool,
                               !status,
                               let message = json["message"] as? String {
                                completion(.failure(.serverMessage(message)))
                            } else {
                                completion(.failure(.decodingError(NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find data at keyPath: \(keyPath)"]))))
                            }
                        }
                    } else {
                        // Direct decoding of the entire response
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        
                        do {
                            let decoded = try decoder.decode(T.self, from: data)
                            completion(.success(decoded))
                        } catch {
                            // If direct decoding fails, check if we have a status/message error format
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let status = json["status"] as? Bool,
                               !status,
                               let message = json["message"] as? String {
                                completion(.failure(.serverMessage(message)))
                            } else {
                                completion(.failure(.decodingError(error)))
                            }
                        }
                    }
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        
        return request
    }
    
    @discardableResult
    func upload<T: Decodable>(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        to endpoint: String,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        authType: AuthType = .function,
        dataField: String? = nil,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) -> UploadRequest {
        let url = buildURL(endpoint: endpoint)
        let finalHeaders = addAuthHeaders(to: headers, authType: authType)
        
        let request = AF.upload(multipartFormData: multipartFormData, to: url, method: method, headers: finalHeaders)
            .validate()
        
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
//                    let decoder = JSONDecoder()
//                    let generalResponse = try decoder.decode(GeneralResponse<T>.self, from: data)
//                    
//                    if generalResponse.status {
//                        completion(.success(generalResponse.data))
//                    } else {
//                        completion(.failure(.serverMessage(generalResponse.message)))
//                    }
                } catch {
                    do {
                        if let dataField = dataField {
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                            if let statusValue = json?["status"] as? Bool, statusValue,
                               let nestedData = json?[dataField] {
                                let nestedDecoder = JSONDecoder()
                                let nestedDataJson = try JSONSerialization.data(withJSONObject: nestedData)
                                let decoded = try nestedDecoder.decode(T.self, from: nestedDataJson)
                                completion(.success(decoded))
                                return
                            }
                        }
                        let fallbackDecoder = JSONDecoder()
                        let decoded = try fallbackDecoder.decode(T.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
        
        return request
    }
}

