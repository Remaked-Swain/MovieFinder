import Foundation

typealias NetworkModelProtocol = NetworkFetchable

final class NetworkModel {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: NetworkModelProtocol Confirmation
extension NetworkModel: NetworkModelProtocol {
    func fetch() {
        
    }
}
