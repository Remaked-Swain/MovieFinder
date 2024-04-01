//
//  NetworkService.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> T
}

fileprivate enum NetworkServiceError: Error {
    case requestFailed
    case badResponse(statusCode: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError
}

final class DefaultNetworkService {
    private let sessionManager: NetworkSessionManager
    private let decoder: JSONDecoder
    
    init(sessionManager: NetworkSessionManager, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }
    
    private func resolveError(error: Error) -> NetworkServiceError {
        if let error = error as? NetworkServiceError {
            return error
        } else {
            let code = URLError.Code(rawValue: (error as NSError).code)
            switch code {
            case .notConnectedToInternet: return .notConnectedToInternet
            default: return .requestFailed
            }
        }
    }
    
    private func handleResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkServiceError.requestFailed
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkServiceError.badResponse(statusCode: response.statusCode)
        }
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data) throws -> T {
        guard let decodedData = try? decoder.decode(type, from: data) else {
            throw NetworkServiceError.decodingError
        }
        return decodedData
    }
}

// MARK: NetworkService Confirmation
extension DefaultNetworkService: NetworkService {
    func request<T: Decodable>(endpoint: Requestable, for type: T.Type) async throws -> T {
        guard let request = endpoint.urlRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await sessionManager.request(request)
            try handleResponse(response)
            let decodedData = try decode(for: type, with: data)
            return decodedData
        } catch {
            throw resolveError(error: error)
        }
    }
}
