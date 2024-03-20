import Foundation

final class NetworkService {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: Private Methods
extension NetworkService {
    private func handleResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.taskingError
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
}

// MARK: NetworkServiceProtocol Confirmation
extension NetworkService: NetworkServiceProtocol {
    func fetchData(to endpoint: EndpointType, delegate: URLSessionTaskDelegate? = nil) async throws -> Data {
        let request = try endpoint.makeURLRequest()
        let (data, response) = try await session.data(for: request, delegate: delegate)
        try handleResponse(response: response)
        return data
    }
}
