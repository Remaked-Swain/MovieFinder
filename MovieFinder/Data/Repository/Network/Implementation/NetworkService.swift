import Foundation

typealias NetworkModelProtocol = NetworkFetchable

final class NetworkModel {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: Private Methods
extension NetworkModel {
    private func makeRequest(by endpoint)
}

// MARK: NetworkModelProtocol Confirmation
extension NetworkModel: NetworkModelProtocol {
    func fetch() {
        session.dataTask(with: <#T##URLRequest#>) { data, response, error in
            <#code#>
        }.resume()
    }
}
