import Foundation

protocol NetworkServiceProtocol {
    func fetchData(to endpoint: EndpointType, delegate: URLSessionTaskDelegate?) async throws -> Data
}
