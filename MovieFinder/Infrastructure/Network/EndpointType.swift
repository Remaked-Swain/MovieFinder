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
    
    var baseURL: String {
        "https://kobis.or.kr/kobisopenapi/webservice/rest"
    }
    
    var endpoint: String {
        switch self {
        case .dailyBoxOffice: "/boxoffice/searchDailyBoxOfficeList.json?"
        case .movieInfo: "/movie/searchMovieInfo.json?"
        }
    }
    
    var httpHeaderField: [String: String] {
        switch self {
        case .dailyBoxOffice(let key, let date): return ["key": key, "targetDt": date.asEightPlaceString]
        case .movieInfo(let key, let code): return ["key": key, "movieCd": code]
        }
    }
}

// MARK: Requestable Confirmation
extension EndpointType: Requestable {
    func urlRequest() -> URLRequest? {
        guard let url = URL(string: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = httpHeaderField
        return request
    }
}
