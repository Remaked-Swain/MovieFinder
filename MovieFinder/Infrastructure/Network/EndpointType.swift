//
//  EndpointType.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

import Foundation

protocol Requestable {
    func urlRequest() -> URLRequest?
}

enum HTTPMethodType {
    case get
    case post
    
    var value: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        }
    }
}

enum EndpointType {
    case dailyBoxOffice(key: String, date: Date)
    case movieInfo(key: String, code: String)
    
    // MARK: Properties
    static let propertyListFileName: String = "KoficAPIKey"
    static let keyName: String = "KOFIC_API_KEY"
    
    var httpMethod: String {
        switch self {
        case .dailyBoxOffice: HTTPMethodType.get.value
        case .movieInfo: HTTPMethodType.get.value
        }
    }
    
    var scheme: String { "https" }
    
    var host: String { "kobis.or.kr" }
    
    var path: String {
        switch self {
        case .dailyBoxOffice: "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        case .movieInfo: "/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .dailyBoxOffice(let key, let date): return makeQueryItems(queries: ("key", key), ("targetDt", date.asEightPlaceString))
        case .movieInfo(let key, let code): return makeQueryItems(queries: ("key", key), ("movieCd", code))
        }
    }
    
    private func makeQueryItems(queries: (key: String, value: String)...) -> [URLQueryItem] {
        return queries.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

// MARK: Requestable Confirmation
extension EndpointType: Requestable {
    func urlRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let fullURL = components.url else { return nil }
        var request = URLRequest(url: fullURL)
        request.httpMethod = httpMethod
        return request
    }
}
