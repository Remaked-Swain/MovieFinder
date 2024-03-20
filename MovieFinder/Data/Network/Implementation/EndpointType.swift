import Foundation

enum EndpointType {
    case dailyBoxOffice(key: String, date: Date)
    case movieInfo(key: String, code: String)
    
    // MARK: Properties
    static let propertyListFileName: String = "KoficAPIKey"
    static let keyName: String = "KOFIC_API_KEY"
    
    var httpMethod: String {
        switch self {
        case .dailyBoxOffice: HTTPMethodType.get
        case .movieInfo: HTTPMethodType.get
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
        case .dailyBoxOffice(let key, let date): return ["key": key, "targetDt": date.asEightPlace]
        case .movieInfo(let key, let code): return ["key": key, "movieCd": code]
        }
    }
}

// MARK: URLRequestConvertible Confirmation
extension EndpointType: URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = httpHeaderField
        return request
    }
}
